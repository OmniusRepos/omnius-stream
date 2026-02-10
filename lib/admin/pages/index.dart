import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import 'package:jaspr_router/jaspr_router.dart';

class AdminPage extends StatelessComponent {
  const AdminPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'min-h-screen bg-[#141414] text-white', children: [
      // Header
      Header(
          className:
              'sticky top-0 z-50 bg-[#141414]/80 backdrop-blur-xl border-b border-white/10',
          children: [
            Div(
                className:
                    'max-w-7xl mx-auto px-6 py-4 flex items-center justify-between',
                children: [
                  Div(className: 'flex items-center gap-4', children: [
                    Link(
                      to: '/',
                      child: Span(
                          className:
                              'text-gray-400 hover:text-white text-sm transition-colors',
                          child: Text('\u2190 Back to Site')),
                    ),
                    Div(
                        className:
                            'w-px h-6 bg-white/10',
                        children: []),
                    H1(
                        className: 'text-xl font-bold text-white',
                        child: Text('Omnius Admin')),
                  ]),
                  Div(id: 'admin-header-actions', className: 'hidden', children: [
                    Button(
                        className:
                            'px-4 py-2 bg-red-500/10 text-red-400 text-sm font-medium rounded-lg hover:bg-red-500/20 transition-colors',
                        attributes: {'id': 'logout-btn'},
                        child: Text('Logout')),
                  ]),
                ]),
          ]),

      // Main content wrapper
      Div(className: 'max-w-7xl mx-auto px-6 py-8', children: [
        // =====================
        // Login Section
        // =====================
        Div(id: 'admin-login-section', className: 'flex items-center justify-center min-h-[70vh]', children: [
          Div(
              className:
                  'w-full max-w-md p-8 rounded-2xl bg-[#1a1a1a] border border-white/10',
              children: [
                Div(className: 'text-center mb-8', children: [
                  Div(
                      className:
                          'inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary-500/10 mb-4',
                      children: [
                        Span(
                            className: 'text-2xl text-primary-500',
                            child: Text('\u{1f6e1}')),
                      ]),
                  H2(
                      className: 'text-2xl font-bold text-white mb-2',
                      child: Text('Admin Access')),
                  P(
                      className: 'text-gray-400 text-sm',
                      child: Text('Enter your admin secret to continue')),
                ]),
                Div(className: 'space-y-4', children: [
                  Div(children: [
                    Label(
                        className: 'block text-sm font-medium text-gray-300 mb-2',
                        child: Text('Admin Secret')),
                    Input(
                        type: 'password',
                        className:
                            'w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 transition-colors',
                        attributes: {
                          'id': 'admin-secret-input',
                          'placeholder': 'Enter admin secret...',
                        }),
                  ]),
                  Div(id: 'login-error', className: 'hidden', children: [
                    P(
                        className:
                            'text-red-400 text-sm bg-red-500/10 rounded-lg px-4 py-2',
                        child: Text('Invalid admin secret. Please try again.')),
                  ]),
                  Button(
                      className:
                          'w-full px-4 py-3 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                      attributes: {'id': 'admin-login-btn'},
                      child: Text('Sign In')),
                ]),
              ]),
        ]),

        // =====================
        // Dashboard Section (hidden until authed)
        // =====================
        Div(id: 'admin-dashboard', className: 'hidden', children: [
          // Stats Row
          Div(id: 'stats-row', className: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8', children: [
            // Total Users
            Div(
                className:
                    'p-6 rounded-xl bg-[#1a1a1a] border border-white/10',
                children: [
                  P(className: 'text-gray-400 text-sm font-medium', child: Text('Total Users')),
                  P(
                      id: 'stat-total-users',
                      className: 'text-3xl font-bold text-white mt-2',
                      child: Text('--')),
                ]),
            // Total Licenses
            Div(
                className:
                    'p-6 rounded-xl bg-[#1a1a1a] border border-white/10',
                children: [
                  P(className: 'text-gray-400 text-sm font-medium', child: Text('Total Licenses')),
                  P(
                      id: 'stat-total-licenses',
                      className: 'text-3xl font-bold text-white mt-2',
                      child: Text('--')),
                ]),
            // Active Licenses
            Div(
                className:
                    'p-6 rounded-xl bg-[#1a1a1a] border border-white/10',
                children: [
                  P(className: 'text-gray-400 text-sm font-medium', child: Text('Active Licenses')),
                  P(
                      id: 'stat-active-licenses',
                      className: 'text-3xl font-bold text-green-400 mt-2',
                      child: Text('--')),
                ]),
            // Active Deployments
            Div(
                className:
                    'p-6 rounded-xl bg-[#1a1a1a] border border-white/10',
                children: [
                  P(className: 'text-gray-400 text-sm font-medium', child: Text('Active Deployments')),
                  P(
                      id: 'stat-active-deployments',
                      className: 'text-3xl font-bold text-primary-500 mt-2',
                      child: Text('--')),
                ]),
          ]),

          // Licenses Section
          Div(className: 'mb-8', children: [
            Div(
                className: 'flex items-center justify-between mb-4',
                children: [
                  H2(
                      className: 'text-xl font-bold text-white',
                      child: Text('Licenses')),
                  Button(
                      className:
                          'px-4 py-2 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                      attributes: {'id': 'create-license-btn'},
                      child: Text('+ Create License')),
                ]),
            // Licenses Table
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
                            child: Text('Key')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Plan')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('User')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Max Deploy')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Status')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Created')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Actions')),
                      ]),
                    ]),
                    Tbody(id: 'licenses-tbody', children: [
                      Tr(children: [
                        Td(
                            className: 'px-6 py-8 text-center text-gray-500',
                            attributes: {'colspan': '7'},
                            child: Text('Loading licenses...')),
                      ]),
                    ]),
                  ]),
                ]),
          ]),

          // =====================
          // Create License Panel (hidden by default)
          // =====================
          Div(
              id: 'create-license-panel',
              className: 'hidden mb-8',
              children: [
                Div(
                    className:
                        'rounded-xl bg-[#1a1a1a] border border-white/10 p-6',
                    children: [
                      Div(
                          className:
                              'flex items-center justify-between mb-6',
                          children: [
                            H3(
                                className: 'text-lg font-bold text-white',
                                child: Text('Create New License')),
                            Button(
                                className:
                                    'text-gray-400 hover:text-white transition-colors text-xl',
                                attributes: {'id': 'close-create-panel'},
                                child: Text('\u2715')),
                          ]),
                      Div(className: 'grid grid-cols-1 md:grid-cols-2 gap-4', children: [
                        // User Email
                        Div(children: [
                          Label(
                              className:
                                  'block text-sm font-medium text-gray-300 mb-2',
                              child: Text('User Email')),
                          Input(
                              type: 'email',
                              className:
                                  'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 transition-colors',
                              attributes: {
                                'id': 'create-user-email',
                                'placeholder': 'user@example.com',
                              }),
                        ]),
                        // Plan
                        Div(children: [
                          Label(
                              className:
                                  'block text-sm font-medium text-gray-300 mb-2',
                              child: Text('Plan')),
                          Select(
                              className:
                                  'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white focus:outline-none focus:border-primary-500 transition-colors',
                              attributes: {'id': 'create-plan'},
                              children: [
                                Option(
                                    attributes: {'value': 'personal'},
                                    child: Text('Personal')),
                                Option(
                                    attributes: {'value': 'business'},
                                    child: Text('Business')),
                                Option(
                                    attributes: {'value': 'enterprise'},
                                    child: Text('Enterprise')),
                              ]),
                        ]),
                        // Max Deployments
                        Div(children: [
                          Label(
                              className:
                                  'block text-sm font-medium text-gray-300 mb-2',
                              child: Text('Max Deployments')),
                          Input(
                              type: 'number',
                              className:
                                  'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 transition-colors',
                              attributes: {
                                'id': 'create-max-deployments',
                                'placeholder': '3',
                                'value': '3',
                              }),
                        ]),
                        // Expires At
                        Div(children: [
                          Label(
                              className:
                                  'block text-sm font-medium text-gray-300 mb-2',
                              child: Text('Expires At')),
                          Input(
                              type: 'date',
                              className:
                                  'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white focus:outline-none focus:border-primary-500 transition-colors',
                              attributes: {
                                'id': 'create-expires-at',
                              }),
                        ]),
                        // Notes (full width)
                        Div(className: 'md:col-span-2', children: [
                          Label(
                              className:
                                  'block text-sm font-medium text-gray-300 mb-2',
                              child: Text('Notes')),
                          Textarea(
                              className:
                                  'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 transition-colors',
                              attributes: {
                                'id': 'create-notes',
                                'rows': '3',
                                'placeholder': 'Optional notes about this license...',
                              },
                              child: Text('')),
                        ]),
                      ]),
                      Div(className: 'flex justify-end mt-6', children: [
                        Button(
                            className:
                                'px-6 py-2.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                            attributes: {'id': 'submit-create-license'},
                            child: Text('Create License')),
                      ]),
                    ]),
              ]),

          // =====================
          // Orders / Transactions Section
          // =====================
          Div(className: 'mb-8', children: [
            H2(
                className: 'text-xl font-bold text-white mb-4',
                child: Text('Transactions (Polar)')),
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
                            child: Text('Status')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                            child: Text('Date')),
                      ]),
                    ]),
                    Tbody(id: 'orders-admin-tbody', children: [
                      Tr(children: [
                        Td(
                            className: 'px-6 py-8 text-center text-gray-500',
                            attributes: {'colspan': '5'},
                            child: Text('Loading transactions...')),
                      ]),
                    ]),
                  ]),
                ]),
          ]),

          // =====================
          // Deployments Panel (hidden by default)
          // =====================
          Div(
              id: 'deployments-panel',
              className: 'hidden mb-8',
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
                                  child: Text('Deployments')),
                              P(
                                  id: 'deployments-license-info',
                                  className: 'text-gray-400 text-sm mt-1',
                                  child: Text('')),
                            ]),
                            Button(
                                className:
                                    'text-gray-400 hover:text-white transition-colors text-xl',
                                attributes: {'id': 'close-deployments-panel'},
                                child: Text('\u2715')),
                          ]),
                      Div(
                          className: 'overflow-x-auto',
                          children: [
                            Table(className: 'w-full text-sm', children: [
                              Thead(children: [
                                Tr(className: 'border-b border-white/10', children: [
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('Machine')),
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('IP')),
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('Version')),
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('Last Seen')),
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('Status')),
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('Actions')),
                                ]),
                              ]),
                              Tbody(id: 'deployments-tbody', children: [
                                Tr(children: [
                                  Td(
                                      className:
                                          'px-4 py-8 text-center text-gray-500',
                                      attributes: {'colspan': '6'},
                                      child: Text('Select a license to view deployments')),
                                ]),
                              ]),
                            ]),
                          ]),
                    ]),
              ]),
        ]),
      ]),

      // =====================
      // Admin Dashboard Script
      // =====================
      script(content: '''
(function() {
  var currentLicenseId = null;

  // ---- Helper: adminFetch ----
  function adminFetch(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    var secret = localStorage.getItem('admin_secret') || '';
    options.headers['x-admin-secret'] = secret;
    if (options.body && typeof options.body === 'object' && !(options.body instanceof FormData)) {
      options.headers['Content-Type'] = 'application/json';
      options.body = JSON.stringify(options.body);
    }
    return fetch(url, options);
  }

  // ---- Auth: attempt login ----
  function attemptLogin() {
    var input = document.getElementById('admin-secret-input');
    var secret = input ? input.value.trim() : '';
    if (!secret) {
      alert('Please enter an admin secret.');
      return;
    }
    localStorage.setItem('admin_secret', secret);
    // Verify by calling stats endpoint
    adminFetch('/api/admin/stats').then(function(res) {
      if (res.ok) {
        showDashboard();
      } else {
        localStorage.removeItem('admin_secret');
        document.getElementById('login-error').classList.remove('hidden');
      }
    }).catch(function() {
      localStorage.removeItem('admin_secret');
      document.getElementById('login-error').classList.remove('hidden');
    });
  }

  // ---- Show dashboard, hide login ----
  function showDashboard() {
    document.getElementById('admin-login-section').classList.add('hidden');
    document.getElementById('admin-dashboard').classList.remove('hidden');
    document.getElementById('admin-header-actions').classList.remove('hidden');
    loadStats();
    loadLicenses();
    loadOrders();
  }

  // ---- Logout ----
  function logout() {
    localStorage.removeItem('admin_secret');
    document.getElementById('admin-login-section').classList.remove('hidden');
    document.getElementById('admin-dashboard').classList.add('hidden');
    document.getElementById('admin-header-actions').classList.add('hidden');
    document.getElementById('login-error').classList.add('hidden');
    var input = document.getElementById('admin-secret-input');
    if (input) input.value = '';
  }

  // ---- Load Stats ----
  function loadStats() {
    adminFetch('/api/admin/stats').then(function(res) {
      if (!res.ok) throw new Error('Failed to load stats');
      return res.json();
    }).then(function(data) {
      var s = data.stats || data;
      document.getElementById('stat-total-users').textContent = s.total_users != null ? s.total_users : '--';
      document.getElementById('stat-total-licenses').textContent = s.total_licenses != null ? s.total_licenses : '--';
      document.getElementById('stat-active-licenses').textContent = s.active_licenses != null ? s.active_licenses : '--';
      document.getElementById('stat-active-deployments').textContent = s.active_deployments != null ? s.active_deployments : '--';
    }).catch(function(err) {
      console.error('Stats error:', err);
    });
  }

  // ---- Load Licenses ----
  function loadLicenses() {
    var tbody = document.getElementById('licenses-tbody');
    tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-gray-500">Loading licenses...</td></tr>';

    adminFetch('/api/admin/licenses').then(function(res) {
      if (!res.ok) throw new Error('Failed to load licenses');
      return res.json();
    }).then(function(data) {
      var licenses = data.licenses || data || [];
      tbody.innerHTML = '';

      if (licenses.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-gray-500">No licenses found.</td></tr>';
        return;
      }

      licenses.forEach(function(lic) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02] transition-colors';

        var isActive = lic.is_active;
        var statusClass = isActive ? 'bg-green-500/10 text-green-400' : 'bg-red-500/10 text-red-400';
        var statusText = isActive ? 'Active' : 'Inactive';
        var toggleText = isActive ? 'Deactivate' : 'Activate';
        var toggleClass = isActive
          ? 'bg-red-500/10 text-red-400 hover:bg-red-500/20'
          : 'bg-green-500/10 text-green-400 hover:bg-green-500/20';
        var created = lic.created_at ? new Date(lic.created_at).toLocaleDateString() : (lic.createdAt ? new Date(lic.createdAt).toLocaleDateString() : 'N/A');
        var keyShort = (lic.license_key || '').length > 20 ? (lic.license_key || '').substring(0, 20) + '...' : (lic.license_key || '');
        var userEmail = lic.user_email || lic.email || 'N/A';

        row.innerHTML = '' +
          '<td class="px-6 py-4"><code class="text-xs font-mono text-gray-300 bg-white/5 px-2 py-1 rounded cursor-pointer" title="' + (lic.license_key || '') + '" onclick="navigator.clipboard.writeText(\\'' + (lic.license_key || '').replace(/'/g, "\\\\'") + '\\')">' + keyShort + '</code></td>' +
          '<td class="px-6 py-4"><span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-primary-500/10 text-primary-400 uppercase">' + (lic.plan || 'N/A') + '</span></td>' +
          '<td class="px-6 py-4 text-gray-300 text-sm">' + userEmail + '</td>' +
          '<td class="px-6 py-4 text-gray-300 text-sm text-center">' + (lic.max_deployments != null ? lic.max_deployments : 'N/A') + '</td>' +
          '<td class="px-6 py-4"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span></td>' +
          '<td class="px-6 py-4 text-gray-400 text-sm">' + created + '</td>' +
          '<td class="px-6 py-4"><div class="flex gap-2">' +
            '<button class="toggle-license-btn text-xs px-3 py-1 rounded-lg font-medium transition-colors ' + toggleClass + '" data-id="' + (lic.id || '') + '" data-active="' + (isActive ? '1' : '0') + '">' + toggleText + '</button>' +
            '<button class="view-deployments-btn text-xs px-3 py-1 rounded-lg font-medium bg-primary-500/10 text-primary-400 hover:bg-primary-500/20 transition-colors" data-id="' + (lic.id || '') + '" data-key="' + (lic.license_key || '') + '">View</button>' +
          '</div></td>';

        tbody.appendChild(row);
      });

      // Attach toggle events
      document.querySelectorAll('.toggle-license-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
          var licId = this.dataset.id;
          var isCurrentlyActive = this.dataset.active === '1';
          var newStatus = isCurrentlyActive ? false : true;
          toggleLicense(licId, newStatus);
        });
      });

      // Attach view deployments events
      document.querySelectorAll('.view-deployments-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
          var licId = this.dataset.id;
          var licKey = this.dataset.key;
          showDeploymentsPanel(licId, licKey);
        });
      });
    }).catch(function(err) {
      console.error('Licenses error:', err);
      tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-red-400">Failed to load licenses.</td></tr>';
    });
  }

  // ---- Load Orders ----
  function loadOrders() {
    var tbody = document.getElementById('orders-admin-tbody');
    tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-8 text-center text-gray-500">Loading transactions...</td></tr>';

    adminFetch('/api/admin/orders').then(function(res) {
      if (!res.ok) throw new Error('Failed to load orders');
      return res.json();
    }).then(function(data) {
      var orders = data.orders || [];
      tbody.innerHTML = '';

      if (orders.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-8 text-center text-gray-500">No transactions yet.</td></tr>';
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
          '<td class="px-6 py-3 text-gray-300 text-sm">' + (order.amount || '0') + ' ' + (order.currency || 'USD') + '</td>' +
          '<td class="px-6 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + ' capitalize">' + (order.status || 'unknown') + '</span></td>' +
          '<td class="px-6 py-3 text-gray-400 text-sm">' + created + '</td>';

        tbody.appendChild(row);
      });
    }).catch(function(err) {
      console.error('Orders error:', err);
      tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-8 text-center text-red-400">Failed to load transactions.</td></tr>';
    });
  }

  // ---- Toggle License Active/Inactive ----
  function toggleLicense(licenseId, setActive) {
    adminFetch('/api/admin/licenses?id=' + licenseId, {
      method: 'PUT',
      body: { is_active: setActive }
    }).then(function(res) {
      if (!res.ok) throw new Error('Failed to toggle license');
      loadStats();
      loadLicenses();
    }).catch(function(err) {
      alert('Error toggling license: ' + err.message);
    });
  }

  // ---- Create License ----
  function createLicense() {
    var email = document.getElementById('create-user-email').value.trim();
    var plan = document.getElementById('create-plan').value;
    var maxDeploy = parseInt(document.getElementById('create-max-deployments').value, 10) || 3;
    var notes = document.getElementById('create-notes').value.trim();
    var expiresAt = document.getElementById('create-expires-at').value;

    if (!email) {
      alert('User email is required.');
      return;
    }

    var body = {
      user_email: email,
      plan: plan,
      max_deployments: maxDeploy,
      notes: notes || null,
      expires_at: expiresAt || null
    };

    adminFetch('/api/admin/licenses', {
      method: 'POST',
      body: body
    }).then(function(res) {
      if (!res.ok) return res.json().then(function(d) { throw new Error(d.error || 'Failed to create license'); });
      return res.json();
    }).then(function(data) {
      // Reset form
      document.getElementById('create-user-email').value = '';
      document.getElementById('create-plan').value = 'personal';
      document.getElementById('create-max-deployments').value = '3';
      document.getElementById('create-notes').value = '';
      document.getElementById('create-expires-at').value = '';
      document.getElementById('create-license-panel').classList.add('hidden');
      loadStats();
      loadLicenses();
      alert('License created successfully!');
    }).catch(function(err) {
      alert('Error creating license: ' + err.message);
    });
  }

  // ---- Show Deployments Panel ----
  function showDeploymentsPanel(licenseId, licenseKey) {
    currentLicenseId = licenseId;
    document.getElementById('deployments-panel').classList.remove('hidden');
    document.getElementById('deployments-license-info').textContent = 'License: ' + (licenseKey || licenseId);
    loadDeployments(licenseId);
    // Scroll to deployments
    document.getElementById('deployments-panel').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  // ---- Load Deployments ----
  function loadDeployments(licenseId) {
    var tbody = document.getElementById('deployments-tbody');
    tbody.innerHTML = '<tr><td colspan="6" class="px-4 py-8 text-center text-gray-500">Loading deployments...</td></tr>';

    adminFetch('/api/admin/deployments?license_id=' + licenseId).then(function(res) {
      if (!res.ok) throw new Error('Failed to load deployments');
      return res.json();
    }).then(function(data) {
      var deployments = data.deployments || data || [];
      tbody.innerHTML = '';

      if (deployments.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="px-4 py-8 text-center text-gray-500">No deployments found for this license.</td></tr>';
        return;
      }

      deployments.forEach(function(dep) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02] transition-colors';

        var isActive = dep.is_active;
        var statusClass = isActive ? 'bg-green-500/10 text-green-400' : 'bg-red-500/10 text-red-400';
        var statusText = isActive ? 'Active' : 'Inactive';
        var lastSeen = dep.last_seen_at ? new Date(dep.last_seen_at).toLocaleString() : 'N/A';
        var machineName = dep.machine_label || dep.machine_fingerprint || 'N/A';
        var ipAddr = dep.ip_address || 'N/A';
        var version = dep.server_version || 'N/A';

        row.innerHTML = '' +
          '<td class="px-4 py-3 text-gray-300 text-sm font-mono">' + machineName + '</td>' +
          '<td class="px-4 py-3 text-gray-400 text-sm">' + ipAddr + '</td>' +
          '<td class="px-4 py-3 text-gray-400 text-sm">' + version + '</td>' +
          '<td class="px-4 py-3 text-gray-400 text-sm">' + lastSeen + '</td>' +
          '<td class="px-4 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span></td>' +
          '<td class="px-4 py-3">' +
            (isActive ? '<button class="deactivate-deploy-btn text-xs px-3 py-1 rounded-lg font-medium bg-red-500/10 text-red-400 hover:bg-red-500/20 transition-colors" data-id="' + (dep.id || '') + '">Deactivate</button>' : '<span class="text-gray-600 text-xs">--</span>') +
          '</td>';

        tbody.appendChild(row);
      });

      // Attach deactivate events
      document.querySelectorAll('.deactivate-deploy-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
          var depId = this.dataset.id;
          deactivateDeployment(depId);
        });
      });
    }).catch(function(err) {
      console.error('Deployments error:', err);
      tbody.innerHTML = '<tr><td colspan="6" class="px-4 py-8 text-center text-red-400">Failed to load deployments.</td></tr>';
    });
  }

  // ---- Deactivate Deployment ----
  function deactivateDeployment(deploymentId) {
    if (!confirm('Are you sure you want to deactivate this deployment?')) return;

    adminFetch('/api/admin/deployments?id=' + deploymentId, {
      method: 'DELETE'
    }).then(function(res) {
      if (!res.ok) throw new Error('Failed to deactivate deployment');
      if (currentLicenseId) {
        loadDeployments(currentLicenseId);
      }
      loadStats();
    }).catch(function(err) {
      alert('Error deactivating deployment: ' + err.message);
    });
  }

  // ---- Event Listeners ----

  // Login button
  var loginBtn = document.getElementById('admin-login-btn');
  if (loginBtn) {
    loginBtn.addEventListener('click', attemptLogin);
  }

  // Enter key on secret input
  var secretInput = document.getElementById('admin-secret-input');
  if (secretInput) {
    secretInput.addEventListener('keydown', function(e) {
      if (e.key === 'Enter') {
        attemptLogin();
      }
    });
  }

  // Logout button
  var logoutBtn = document.getElementById('logout-btn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', logout);
  }

  // Create license toggle
  var createBtn = document.getElementById('create-license-btn');
  if (createBtn) {
    createBtn.addEventListener('click', function() {
      document.getElementById('create-license-panel').classList.toggle('hidden');
    });
  }

  // Close create panel
  var closeCreateBtn = document.getElementById('close-create-panel');
  if (closeCreateBtn) {
    closeCreateBtn.addEventListener('click', function() {
      document.getElementById('create-license-panel').classList.add('hidden');
    });
  }

  // Submit create license
  var submitCreateBtn = document.getElementById('submit-create-license');
  if (submitCreateBtn) {
    submitCreateBtn.addEventListener('click', createLicense);
  }

  // Close deployments panel
  var closeDeploymentsBtn = document.getElementById('close-deployments-panel');
  if (closeDeploymentsBtn) {
    closeDeploymentsBtn.addEventListener('click', function() {
      document.getElementById('deployments-panel').classList.add('hidden');
      currentLicenseId = null;
    });
  }

  // ---- Auto-login if secret exists ----
  var existingSecret = localStorage.getItem('admin_secret');
  if (existingSecret) {
    adminFetch('/api/admin/stats').then(function(res) {
      if (res.ok) {
        showDashboard();
      } else {
        localStorage.removeItem('admin_secret');
      }
    }).catch(function() {
      localStorage.removeItem('admin_secret');
    });
  }
})();
      '''),
    ]);
  }
}
