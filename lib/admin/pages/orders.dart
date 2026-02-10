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

      // Tab switcher: Local DB vs Polar API
      Div(
          className: 'flex gap-2 mb-6',
          children: [
            Button(
                className:
                    'orders-tab px-4 py-2 text-sm font-medium rounded-lg bg-white/5 text-white border border-white/10 transition-colors',
                attributes: {'data-tab': 'local'},
                child: Text('Local Orders')),
            Button(
                className:
                    'orders-tab px-4 py-2 text-sm font-medium rounded-lg text-gray-400 hover:text-white hover:bg-white/5 transition-colors',
                attributes: {'data-tab': 'polar'},
                child: Text('Polar (Live)')),
          ]),

      // Local Orders Table
      Div(
          id: 'local-orders-section',
          children: [
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
                            child: Text('Transaction ID')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('User')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Amount')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Currency')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Status')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Date')),
                      ]),
                    ]),
                    Tbody(id: 'local-orders-tbody', children: [
                      Tr(children: [
                        Td(
                            className: 'px-6 py-8 text-center text-gray-500',
                            attributes: {'colspan': '6'},
                            child: Text('Loading local orders...')),
                      ]),
                    ]),
                  ]),
                ]),
          ]),

      // Polar Live Orders Section (hidden by default)
      Div(
          id: 'polar-orders-section',
          className: 'hidden',
          children: [
            // Polar customers summary
            Div(className: 'mb-6', children: [
              H2(
                  className: 'text-lg font-semibold text-white mb-3',
                  child: Text('Polar Customers')),
              Div(
                  className:
                      'rounded-xl bg-[#1a1a1a] border border-white/10 overflow-hidden overflow-x-auto',
                  children: [
                    Table(className: 'w-full text-sm', children: [
                      Thead(children: [
                        Tr(
                            className: 'border-b border-white/10',
                            children: [
                              Th(
                                  className:
                                      'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                  child: Text('Email')),
                              Th(
                                  className:
                                      'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                  child: Text('Name')),
                              Th(
                                  className:
                                      'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                  child: Text('Created')),
                            ]),
                      ]),
                      Tbody(id: 'polar-customers-tbody', children: [
                        Tr(children: [
                          Td(
                              className:
                                  'px-6 py-8 text-center text-gray-500',
                              attributes: {'colspan': '3'},
                              child: Text('Loading Polar customers...')),
                        ]),
                      ]),
                    ]),
                  ]),
            ]),

            // Polar orders
            Div(children: [
              H2(
                  className: 'text-lg font-semibold text-white mb-3',
                  child: Text('Polar Orders (Live)')),
              Div(
                  id: 'polar-pagination-info',
                  className: 'text-gray-500 text-sm mb-2',
                  children: []),
              Div(
                  className:
                      'rounded-xl bg-[#1a1a1a] border border-white/10 overflow-hidden overflow-x-auto',
                  children: [
                    Table(className: 'w-full text-sm', children: [
                      Thead(children: [
                        Tr(
                            className: 'border-b border-white/10',
                            children: [
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
                            ]),
                      ]),
                      Tbody(id: 'polar-orders-tbody', children: [
                        Tr(children: [
                          Td(
                              className:
                                  'px-6 py-8 text-center text-gray-500',
                              attributes: {'colspan': '6'},
                              child: Text('Loading Polar orders...')),
                        ]),
                      ]),
                    ]),
                  ]),
              // Pagination
              Div(
                  id: 'polar-orders-pagination',
                  className: 'flex gap-2 mt-4 justify-center',
                  children: []),
            ]),
          ]),

      // Page Script
      script(content: '''
(function() {
  var currentPolarPage = 1;

  function adminFetch(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.credentials = 'same-origin';
    return fetch(url, options);
  }

  // Tab switching
  document.querySelectorAll('.orders-tab').forEach(function(btn) {
    btn.addEventListener('click', function() {
      var tab = this.dataset.tab;
      // Update tab styles
      document.querySelectorAll('.orders-tab').forEach(function(t) {
        t.className = 'orders-tab px-4 py-2 text-sm font-medium rounded-lg text-gray-400 hover:text-white hover:bg-white/5 transition-colors';
      });
      this.className = 'orders-tab px-4 py-2 text-sm font-medium rounded-lg bg-white/5 text-white border border-white/10 transition-colors';

      if (tab === 'local') {
        document.getElementById('local-orders-section').classList.remove('hidden');
        document.getElementById('polar-orders-section').classList.add('hidden');
      } else {
        document.getElementById('local-orders-section').classList.add('hidden');
        document.getElementById('polar-orders-section').classList.remove('hidden');
        loadPolarCustomers();
        loadPolarOrders(1);
      }
    });
  });

  // Load local orders
  function loadLocalOrders() {
    var tbody = document.getElementById('local-orders-tbody');
    tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">Loading...</td></tr>';

    adminFetch('/api/admin/orders').then(function(res) {
      if (!res.ok) throw new Error('Failed');
      return res.json();
    }).then(function(data) {
      var orders = data.orders || [];
      tbody.innerHTML = '';

      if (orders.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">No local orders.</td></tr>';
        return;
      }

      orders.forEach(function(order) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02] transition-colors';
        var created = order.createdAt ? new Date(order.createdAt).toLocaleDateString() : 'N/A';
        var statusClass = order.status === 'completed' ? 'bg-green-500/10 text-green-400' : 'bg-yellow-500/10 text-yellow-400';

        row.innerHTML = '' +
          '<td class="px-6 py-3 text-gray-300 font-mono text-xs">' + (order.transaction_id || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (order.user_email || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (order.amount || '0') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (order.currency || 'USD') + '</td>' +
          '<td class="px-6 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + ' capitalize">' + (order.status || 'unknown') + '</span></td>' +
          '<td class="px-6 py-3 text-gray-400 text-sm">' + created + '</td>';

        tbody.appendChild(row);
      });
    }).catch(function(err) {
      tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-red-400">Failed to load orders.</td></tr>';
    });
  }

  // Load Polar customers (live from API)
  function loadPolarCustomers() {
    var tbody = document.getElementById('polar-customers-tbody');
    tbody.innerHTML = '<tr><td colspan="3" class="px-6 py-6 text-center text-gray-500">Loading Polar customers...</td></tr>';

    adminFetch('/api/admin/polar/customers?limit=50').then(function(res) {
      if (!res.ok) throw new Error('Polar API unavailable');
      return res.json();
    }).then(function(data) {
      var items = data.items || [];
      tbody.innerHTML = '';

      if (items.length === 0) {
        tbody.innerHTML = '<tr><td colspan="3" class="px-6 py-6 text-center text-gray-500">No Polar customers.</td></tr>';
        return;
      }

      items.forEach(function(c) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02]';
        var created = c.created_at ? new Date(c.created_at).toLocaleDateString() : 'N/A';
        row.innerHTML = '' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (c.email || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (c.name || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-400 text-sm">' + created + '</td>';
        tbody.appendChild(row);
      });
    }).catch(function(err) {
      tbody.innerHTML = '<tr><td colspan="3" class="px-6 py-6 text-center text-yellow-400">Polar API not configured. Set POLAR_ACCESS_TOKEN env var.</td></tr>';
    });
  }

  // Load Polar orders (live from API)
  function loadPolarOrders(page) {
    currentPolarPage = page || 1;
    var tbody = document.getElementById('polar-orders-tbody');
    tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-6 text-center text-gray-500">Loading Polar orders...</td></tr>';

    adminFetch('/api/admin/polar/orders?page=' + currentPolarPage + '&limit=20&sorting=-created_at').then(function(res) {
      if (!res.ok) throw new Error('Polar API unavailable');
      return res.json();
    }).then(function(data) {
      var items = data.items || [];
      var pagination = data.pagination || {};
      tbody.innerHTML = '';

      // Show pagination info
      var infoEl = document.getElementById('polar-pagination-info');
      infoEl.textContent = 'Total: ' + (pagination.total_count || 0) + ' orders | Page ' + currentPolarPage + ' of ' + (pagination.max_page || 1);

      if (items.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-6 text-center text-gray-500">No Polar orders.</td></tr>';
        return;
      }

      items.forEach(function(order) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02]';
        var created = order.created_at ? new Date(order.created_at).toLocaleDateString() : 'N/A';
        var amount = order.amount ? (order.amount / 100).toFixed(2) : '0.00';
        var currency = (order.currency || 'usd').toUpperCase();
        var customer = order.customer || {};
        var product = order.product || {};

        row.innerHTML = '' +
          '<td class="px-6 py-3 text-gray-300 font-mono text-xs">' + (order.id || 'N/A').substring(0, 12) + '...</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (customer.email || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (product.name || 'N/A') + '</td>' +
          '<td class="px-6 py-3 text-gray-300 text-sm">' + amount + ' ' + currency + '</td>' +
          '<td class="px-6 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full bg-green-500/10 text-green-400 capitalize">' + (order.status || 'unknown') + '</span></td>' +
          '<td class="px-6 py-3 text-gray-400 text-sm">' + created + '</td>';

        tbody.appendChild(row);
      });

      // Render pagination buttons
      var paginationEl = document.getElementById('polar-orders-pagination');
      paginationEl.innerHTML = '';
      var maxPage = pagination.max_page || 1;
      if (maxPage > 1) {
        if (currentPolarPage > 1) {
          var prevBtn = document.createElement('button');
          prevBtn.className = 'px-3 py-1 text-sm rounded-lg bg-white/5 text-gray-300 hover:text-white transition-colors';
          prevBtn.textContent = 'Prev';
          prevBtn.addEventListener('click', function() { loadPolarOrders(currentPolarPage - 1); });
          paginationEl.appendChild(prevBtn);
        }
        var pageInfo = document.createElement('span');
        pageInfo.className = 'px-3 py-1 text-sm text-gray-500';
        pageInfo.textContent = currentPolarPage + ' / ' + maxPage;
        paginationEl.appendChild(pageInfo);
        if (currentPolarPage < maxPage) {
          var nextBtn = document.createElement('button');
          nextBtn.className = 'px-3 py-1 text-sm rounded-lg bg-white/5 text-gray-300 hover:text-white transition-colors';
          nextBtn.textContent = 'Next';
          nextBtn.addEventListener('click', function() { loadPolarOrders(currentPolarPage + 1); });
          paginationEl.appendChild(nextBtn);
        }
      }
    }).catch(function(err) {
      tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-6 text-center text-yellow-400">Polar API not configured. Set POLAR_ACCESS_TOKEN env var.</td></tr>';
    });
  }

  // Initial load
  loadLocalOrders();
})();
      '''),
    ]);
  }
}
