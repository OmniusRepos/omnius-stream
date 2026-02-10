import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;

class AdminOrdersPage extends StatelessComponent {
  const AdminOrdersPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'p-6 text-white', children: [
      // Page Header
      H1(
          className: 'text-2xl font-bold text-white mb-6',
          child: Text('Orders')),

      // Pagination info
      Div(
          id: 'orders-pagination-info',
          className: 'text-gray-500 text-sm mb-3',
          children: []),

      // Orders Table
      Div(
          className:
              'rounded-xl bg-[#1a1a1a] border border-white/10 overflow-hidden overflow-x-auto',
          children: [
            Table(className: 'w-full text-sm', children: [
              Thead(children: [
                Tr(className: 'border-b border-white/10', children: [
                  Th(
                      className:
                          'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                      child: Text('Order ID')),
                  Th(
                      className:
                          'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                      child: Text('Customer')),
                  Th(
                      className:
                          'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                      child: Text('Product')),
                  Th(
                      className:
                          'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                      child: Text('Amount')),
                  Th(
                      className:
                          'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                      child: Text('Status')),
                  Th(
                      className:
                          'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                      child: Text('Date')),
                  Th(
                      className:
                          'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                      child: Text('Actions')),
                ]),
              ]),
              Tbody(id: 'orders-tbody', children: [
                Tr(children: [
                  Td(
                      className: 'px-6 py-8 text-center text-gray-500',
                      attributes: {'colspan': '7'},
                      child: Text('Loading orders...')),
                ]),
              ]),
            ]),
          ]),

      // Pagination buttons
      Div(
          id: 'orders-pagination',
          className: 'flex gap-2 mt-4 justify-center',
          children: []),

      // Page Script
      script(content: '''
(function() {
  var currentPage = 1;

  function adminFetch(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.credentials = 'same-origin';
    return fetch(url, options);
  }

  function loadOrders(page) {
    currentPage = page || 1;
    var tbody = document.getElementById('orders-tbody');
    tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-gray-500">Loading orders...</td></tr>';

    adminFetch('/api/admin/polar/orders?page=' + currentPage + '&limit=20&sorting=-created_at').then(function(res) {
      if (!res.ok) throw new Error('Polar API unavailable');
      return res.json();
    }).then(function(data) {
      var items = data.items || [];
      var pagination = data.pagination || {};
      tbody.innerHTML = '';

      var infoEl = document.getElementById('orders-pagination-info');
      infoEl.textContent = 'Total: ' + (pagination.total_count || 0) + ' orders';

      if (items.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-gray-500">No orders found.</td></tr>';
        return;
      }

      items.forEach(function(order) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02] transition-colors';
        var created = order.created_at ? new Date(order.created_at).toLocaleDateString() : 'N/A';
        var amount = order.amount ? (order.amount / 100).toFixed(2) : '0.00';
        var currency = (order.currency || 'usd').toUpperCase();
        var customer = order.customer || {};
        var product = order.product || {};
        var statusColor = order.status === 'paid' ? 'bg-green-500/10 text-green-400' : 'bg-yellow-500/10 text-yellow-400';

        row.innerHTML = '' +
          '<td class="px-6 py-3 text-gray-300 font-mono text-xs">' + (order.id || 'N/A').substring(0, 12) + '...</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (customer.email || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (product.name || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + amount + ' ' + currency + '</td>' +
          '<td class="px-6 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusColor + ' capitalize">' + (order.status || 'unknown') + '</span></td>' +
          '<td class="px-6 py-3 text-gray-400 text-sm">' + created + '</td>' +
          '<td class="px-6 py-3" id="action-' + order.id + '"></td>';

        tbody.appendChild(row);

        // Check if this order is already synced and add appropriate button
        checkSyncStatus(order.id);
      });

      // Pagination
      var paginationEl = document.getElementById('orders-pagination');
      paginationEl.innerHTML = '';
      var maxPage = pagination.max_page || 1;
      if (maxPage > 1) {
        if (currentPage > 1) {
          var prevBtn = document.createElement('button');
          prevBtn.className = 'px-3 py-1 text-sm rounded-lg bg-white/5 text-gray-300 hover:text-white transition-colors';
          prevBtn.textContent = 'Prev';
          prevBtn.addEventListener('click', function() { loadOrders(currentPage - 1); });
          paginationEl.appendChild(prevBtn);
        }
        var pageInfo = document.createElement('span');
        pageInfo.className = 'px-3 py-1 text-sm text-gray-500';
        pageInfo.textContent = currentPage + ' / ' + maxPage;
        paginationEl.appendChild(pageInfo);
        if (currentPage < maxPage) {
          var nextBtn = document.createElement('button');
          nextBtn.className = 'px-3 py-1 text-sm rounded-lg bg-white/5 text-gray-300 hover:text-white transition-colors';
          nextBtn.textContent = 'Next';
          nextBtn.addEventListener('click', function() { loadOrders(currentPage + 1); });
          paginationEl.appendChild(nextBtn);
        }
      }
    }).catch(function(err) {
      tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-red-400">Failed to load orders from Polar.</td></tr>';
    });
  }

  // Cache of synced order IDs (loaded once)
  var syncedOrders = {};
  var syncedLoaded = false;

  function loadSyncedOrders() {
    return adminFetch('/api/admin/orders').then(function(res) {
      if (!res.ok) return;
      return res.json();
    }).then(function(data) {
      if (!data) return;
      (data.orders || []).forEach(function(o) {
        if (o.transaction_id) syncedOrders[o.transaction_id] = true;
      });
      syncedLoaded = true;
    });
  }

  function checkSyncStatus(orderId) {
    var cell = document.getElementById('action-' + orderId);
    if (!cell) return;

    if (syncedOrders[orderId]) {
      cell.innerHTML = '<span class="text-xs text-green-400 font-medium">Synced</span>';
    } else {
      var btn = document.createElement('button');
      btn.className = 'px-3 py-1 text-xs font-medium rounded-lg bg-primary-500/10 text-primary-400 hover:bg-primary-500/20 transition-colors';
      btn.textContent = 'Sync';
      btn.addEventListener('click', function() { syncOrder(orderId, btn); });
      cell.innerHTML = '';
      cell.appendChild(btn);
    }
  }

  function syncOrder(orderId, btn) {
    btn.disabled = true;
    btn.textContent = 'Syncing...';
    btn.className = 'px-3 py-1 text-xs font-medium rounded-lg bg-white/5 text-gray-500';

    adminFetch('/api/admin/polar/sync', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ order_id: orderId })
    }).then(function(res) {
      return res.json();
    }).then(function(data) {
      var cell = document.getElementById('action-' + orderId);
      if (data.status === 'synced' || data.status === 'already_synced') {
        syncedOrders[orderId] = true;
        cell.innerHTML = '<span class="text-xs text-green-400 font-medium">Synced</span>';
      } else {
        cell.innerHTML = '<span class="text-xs text-red-400">' + (data.error || 'Failed') + '</span>';
      }
    }).catch(function() {
      btn.textContent = 'Retry';
      btn.disabled = false;
      btn.className = 'px-3 py-1 text-xs font-medium rounded-lg bg-red-500/10 text-red-400 hover:bg-red-500/20 transition-colors';
    });
  }

  // Load synced status first, then load orders
  loadSyncedOrders().then(function() {
    loadOrders(1);
  });
})();
      '''),
    ]);
  }
}
