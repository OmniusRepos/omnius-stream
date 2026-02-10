import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;

class AdminCustomersPage extends StatelessComponent {
  const AdminCustomersPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'p-6 text-white', children: [
      // Page Header
      H1(
          className: 'text-2xl font-bold text-white mb-6',
          child: Text('Customers')),

      // Stats Row
      Div(
          id: 'stats-row',
          className:
              'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8',
          children: [
            _statCard('stat-total-users', 'Total Users'),
            _statCard('stat-total-licenses', 'Total Licenses'),
            _statCard('stat-active-licenses', 'Active Licenses',
                valueClass: 'text-green-400'),
            _statCard('stat-active-deployments', 'Active Deployments',
                valueClass: 'text-primary-500'),
          ]),

      // Customers Table
      Div(
          className:
              'rounded-xl bg-[#1a1a1a] border border-white/10 overflow-hidden',
          children: [
            Table(className: 'w-full text-sm', children: [
              Thead(children: [
                Tr(className: 'border-b border-white/10', children: [
                  _th('Email'),
                  _th('Name'),
                  _th('Licenses'),
                  _th('Status'),
                  _th('Created'),
                  _th('Actions'),
                ]),
              ]),
              Tbody(id: 'customers-tbody', children: [
                Tr(children: [
                  Td(
                      className: 'px-6 py-8 text-center text-gray-500',
                      attributes: {'colspan': '6'},
                      child: Text('Loading customers...')),
                ]),
              ]),
            ]),
          ]),

      // Customer Detail Panel (hidden by default)
      Div(
          id: 'customer-detail-panel',
          className: 'hidden mt-6',
          children: [
            Div(
                className:
                    'rounded-xl bg-[#1a1a1a] border border-white/10 p-6',
                children: [
                  Div(
                      className:
                          'flex items-center justify-between mb-6',
                      children: [
                        Div(children: [
                          H3(
                              className: 'text-lg font-bold text-white',
                              child: Text('Customer Details')),
                          P(
                              id: 'customer-detail-info',
                              className: 'text-gray-400 text-sm mt-1',
                              child: Text('')),
                        ]),
                        Button(
                            className:
                                'text-gray-400 hover:text-white transition-colors text-xl',
                            attributes: {'id': 'close-detail-panel'},
                            child: Text('\u2715')),
                      ]),

                  // Licenses sub-table
                  H4(
                      className:
                          'text-sm font-semibold text-gray-300 uppercase tracking-wider mb-3',
                      child: Text('Licenses')),
                  Div(
                      className:
                          'rounded-lg border border-white/5 overflow-hidden overflow-x-auto mb-6',
                      children: [
                        Table(className: 'w-full text-sm', children: [
                          Thead(children: [
                            Tr(
                                className: 'border-b border-white/10',
                                children: [
                                  _th('Key', px: 4),
                                  _th('Plan', px: 4),
                                  _th('Max Deploy', px: 4),
                                  _th('Status', px: 4),
                                  _th('Created', px: 4),
                                  _th('Actions', px: 4),
                                ]),
                          ]),
                          Tbody(id: 'customer-licenses-tbody', children: [
                            Tr(children: [
                              Td(
                                  className:
                                      'px-4 py-4 text-center text-gray-500',
                                  attributes: {'colspan': '6'},
                                  child: Text('No licenses')),
                            ]),
                          ]),
                        ]),
                      ]),

                  // Transactions sub-table
                  H4(
                      className:
                          'text-sm font-semibold text-gray-300 uppercase tracking-wider mb-3',
                      child: Text('Transactions')),
                  Div(
                      className:
                          'rounded-lg border border-white/5 overflow-hidden overflow-x-auto mb-6',
                      children: [
                        Table(className: 'w-full text-sm', children: [
                          Thead(children: [
                            Tr(
                                className: 'border-b border-white/10',
                                children: [
                                  _th('Order ID', px: 4),
                                  _th('Amount', px: 4),
                                  _th('Currency', px: 4),
                                  _th('Status', px: 4),
                                  _th('Date', px: 4),
                                ]),
                          ]),
                          Tbody(
                              id: 'customer-orders-tbody',
                              children: [
                                Tr(children: [
                                  Td(
                                      className:
                                          'px-4 py-4 text-center text-gray-500',
                                      attributes: {'colspan': '5'},
                                      child: Text('No transactions')),
                                ]),
                              ]),
                        ]),
                      ]),

                  // Deployments sub-table
                  Div(
                      id: 'customer-deployments-section',
                      className: 'hidden',
                      children: [
                        H4(
                            className:
                                'text-sm font-semibold text-gray-300 uppercase tracking-wider mb-3',
                            child: Text('Deployments')),
                        P(
                            id: 'customer-deployments-license-info',
                            className: 'text-gray-500 text-xs mb-2',
                            child: Text('')),
                        Div(
                            className:
                                'rounded-lg border border-white/5 overflow-hidden overflow-x-auto',
                            children: [
                              Table(className: 'w-full text-sm', children: [
                                Thead(children: [
                                  Tr(
                                      className:
                                          'border-b border-white/10',
                                      children: [
                                        _th('Machine', px: 4),
                                        _th('Domain', px: 4),
                                        _th('IP', px: 4),
                                        _th('Version', px: 4),
                                        _th('Last Seen', px: 4),
                                        _th('Status', px: 4),
                                      ]),
                                ]),
                                Tbody(
                                    id: 'customer-deployments-tbody',
                                    children: [
                                      Tr(children: [
                                        Td(
                                            className:
                                                'px-4 py-4 text-center text-gray-500',
                                            attributes: {'colspan': '6'},
                                            child: Text('No deployments')),
                                      ]),
                                    ]),
                              ]),
                            ]),
                      ]),
                ]),
          ]),

      // Page Script
      script(content: '''
(function() {
  function adminFetch(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.credentials = 'same-origin';
    if (options.body && typeof options.body === 'object' && !(options.body instanceof FormData)) {
      options.headers['Content-Type'] = 'application/json';
      options.body = JSON.stringify(options.body);
    }
    return fetch(url, options);
  }

  // Load stats
  adminFetch('/api/admin/stats').then(function(res) {
    if (!res.ok) return;
    return res.json();
  }).then(function(data) {
    if (!data) return;
    var s = data;
    document.getElementById('stat-total-users').textContent = s.total_users != null ? s.total_users : '--';
    document.getElementById('stat-total-licenses').textContent = s.total_licenses != null ? s.total_licenses : '--';
    document.getElementById('stat-active-licenses').textContent = s.active_licenses != null ? s.active_licenses : '--';
    document.getElementById('stat-active-deployments').textContent = s.active_deployments != null ? s.active_deployments : '--';
  });

  // Load customers
  function loadCustomers() {
    var tbody = document.getElementById('customers-tbody');
    tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">Loading customers...</td></tr>';

    adminFetch('/api/admin/users').then(function(res) {
      if (!res.ok) throw new Error('Failed');
      return res.json();
    }).then(function(data) {
      var users = data.users || [];
      tbody.innerHTML = '';

      if (users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">No customers found.</td></tr>';
        return;
      }

      users.forEach(function(user) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02] transition-colors cursor-pointer';
        var statusClass = user.is_active ? 'bg-green-500/10 text-green-400' : 'bg-red-500/10 text-red-400';
        var statusText = user.is_active ? 'Active' : 'Inactive';
        var created = user.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'N/A';

        row.innerHTML = '' +
          '<td class="px-6 py-4 text-gray-300 text-sm">' + (user.email || 'N/A') + '</td>' +
          '<td class="px-6 py-4 text-gray-300 text-sm">' + (user.name || 'N/A') + '</td>' +
          '<td class="px-6 py-4 text-gray-300 text-sm text-center">' + (user.license_count || 0) + '</td>' +
          '<td class="px-6 py-4"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span></td>' +
          '<td class="px-6 py-4 text-gray-400 text-sm">' + created + '</td>' +
          '<td class="px-6 py-4"><button class="view-customer-btn text-xs px-3 py-1 rounded-lg font-medium bg-primary-500/10 text-primary-400 hover:bg-primary-500/20 transition-colors" data-id="' + (user.id || '') + '" data-email="' + (user.email || '') + '">View</button></td>';

        tbody.appendChild(row);
      });

      // View customer events
      document.querySelectorAll('.view-customer-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
          e.stopPropagation();
          showCustomerDetail(this.dataset.id, this.dataset.email);
        });
      });
    }).catch(function(err) {
      tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-red-400">Failed to load customers.</td></tr>';
    });
  }

  function showCustomerDetail(userId, email) {
    var panel = document.getElementById('customer-detail-panel');
    panel.classList.remove('hidden');
    document.getElementById('customer-detail-info').textContent = email;
    document.getElementById('customer-deployments-section').classList.add('hidden');

    // Load user detail
    adminFetch('/api/admin/users/detail?id=' + userId).then(function(res) {
      if (!res.ok) throw new Error('Failed');
      return res.json();
    }).then(function(data) {
      // Render licenses
      var licTbody = document.getElementById('customer-licenses-tbody');
      var lics = data.licenses || [];
      licTbody.innerHTML = '';

      if (lics.length === 0) {
        licTbody.innerHTML = '<tr><td colspan="6" class="px-4 py-4 text-center text-gray-500">No licenses</td></tr>';
      } else {
        lics.forEach(function(lic) {
          var row = document.createElement('tr');
          row.className = 'border-b border-white/5 hover:bg-white/[0.02]';
          var isActive = lic.is_active;
          var statusClass = isActive ? 'bg-green-500/10 text-green-400' : 'bg-red-500/10 text-red-400';
          var statusText = isActive ? 'Active' : 'Inactive';
          var created = lic.createdAt ? new Date(lic.createdAt).toLocaleDateString() : 'N/A';
          var keyShort = (lic.license_key || '').length > 16 ? (lic.license_key || '').substring(0, 16) + '...' : (lic.license_key || '');

          row.innerHTML = '' +
            '<td class="px-4 py-3"><code class="text-xs font-mono text-gray-300 bg-white/5 px-2 py-1 rounded cursor-pointer" title="' + (lic.license_key || '') + '" onclick="navigator.clipboard.writeText(\\'' + (lic.license_key || '').replace(/'/g, "\\\\'") + '\\')">' + keyShort + '</code></td>' +
            '<td class="px-4 py-3"><span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-primary-500/10 text-primary-400 uppercase">' + (lic.plan || 'N/A') + '</span></td>' +
            '<td class="px-4 py-3 text-gray-300 text-sm text-center">' + (lic.max_deployments != null ? lic.max_deployments : 'N/A') + '</td>' +
            '<td class="px-4 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span></td>' +
            '<td class="px-4 py-3 text-gray-400 text-sm">' + created + '</td>' +
            '<td class="px-4 py-3"><button class="show-deploys-btn text-xs px-3 py-1 rounded-lg font-medium bg-primary-500/10 text-primary-400 hover:bg-primary-500/20 transition-colors" data-key="' + (lic.license_key || '') + '">Deployments</button></td>';

          // Store deployments data on the row
          row._deployments = lic.deployments || [];
          tbody_licAppendRow(licTbody, row, lic);
        });
      }

      // Render orders
      var ordTbody = document.getElementById('customer-orders-tbody');
      var ords = data.orders || [];
      ordTbody.innerHTML = '';

      if (ords.length === 0) {
        ordTbody.innerHTML = '<tr><td colspan="5" class="px-4 py-4 text-center text-gray-500">No transactions</td></tr>';
      } else {
        ords.forEach(function(order) {
          var row = document.createElement('tr');
          row.className = 'border-b border-white/5';
          var created = order.createdAt ? new Date(order.createdAt).toLocaleDateString() : 'N/A';
          var statusClass = order.status === 'completed' ? 'bg-green-500/10 text-green-400' : 'bg-yellow-500/10 text-yellow-400';
          row.innerHTML = '' +
            '<td class="px-4 py-3 text-gray-300 font-mono text-xs">' + (order.transaction_id || 'N/A') + '</td>' +
            '<td class="px-4 py-3 text-gray-300 text-sm">' + (order.amount || '0') + '</td>' +
            '<td class="px-4 py-3 text-gray-300 text-sm">' + (order.currency || 'USD') + '</td>' +
            '<td class="px-4 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + ' capitalize">' + (order.status || 'unknown') + '</span></td>' +
            '<td class="px-4 py-3 text-gray-400 text-sm">' + created + '</td>';
          ordTbody.appendChild(row);
        });
      }

      // Scroll to panel
      panel.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }).catch(function(err) {
      console.error('Customer detail error:', err);
    });
  }

  function tbody_licAppendRow(licTbody, row, lic) {
    licTbody.appendChild(row);
    // Attach deployment viewer
    var btn = row.querySelector('.show-deploys-btn');
    if (btn) {
      btn.addEventListener('click', function() {
        showDeployments(lic.deployments || [], lic.license_key);
      });
    }
  }

  function showDeployments(deploys, licenseKey) {
    var section = document.getElementById('customer-deployments-section');
    section.classList.remove('hidden');
    document.getElementById('customer-deployments-license-info').textContent = 'License: ' + (licenseKey || '');

    var tbody = document.getElementById('customer-deployments-tbody');
    tbody.innerHTML = '';

    if (deploys.length === 0) {
      tbody.innerHTML = '<tr><td colspan="6" class="px-4 py-4 text-center text-gray-500">No deployments</td></tr>';
      return;
    }

    deploys.forEach(function(dep) {
      var row = document.createElement('tr');
      row.className = 'border-b border-white/5';
      var isActive = dep.is_active;
      var statusClass = isActive ? 'bg-green-500/10 text-green-400' : 'bg-red-500/10 text-red-400';
      var statusText = isActive ? 'Active' : 'Inactive';
      var lastSeen = dep.last_seen_at ? new Date(dep.last_seen_at).toLocaleString() : 'N/A';

      row.innerHTML = '' +
        '<td class="px-4 py-3 text-gray-300 text-sm font-mono">' + (dep.machine_label || dep.machine_fingerprint || 'N/A') + '</td>' +
        '<td class="px-4 py-3 text-gray-400 text-sm">' + (dep.domain || 'N/A') + '</td>' +
        '<td class="px-4 py-3 text-gray-400 text-sm">' + (dep.ip_address || 'N/A') + '</td>' +
        '<td class="px-4 py-3 text-gray-400 text-sm">' + (dep.server_version || 'N/A') + '</td>' +
        '<td class="px-4 py-3 text-gray-400 text-sm">' + lastSeen + '</td>' +
        '<td class="px-4 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span></td>';

      tbody.appendChild(row);
    });
  }

  // Close detail panel
  var closeBtn = document.getElementById('close-detail-panel');
  if (closeBtn) {
    closeBtn.addEventListener('click', function() {
      document.getElementById('customer-detail-panel').classList.add('hidden');
    });
  }

  loadCustomers();
})();
      '''),
    ]);
  }
}

Component _statCard(String id, String label, {String valueClass = 'text-white'}) {
  return Div(
      className: 'p-6 rounded-xl bg-[#1a1a1a] border border-white/10',
      children: [
        P(
            className: 'text-gray-400 text-sm font-medium',
            child: Text(label)),
        P(
            id: id,
            className: 'text-3xl font-bold $valueClass mt-2',
            child: Text('--')),
      ]);
}

Component _th(String text, {int px = 6}) {
  return Th(
      className:
          'text-left px-${px} py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
      child: Text(text));
}
