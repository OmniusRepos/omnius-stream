import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;

class AdminLicensesPage extends StatelessComponent {
  const AdminLicensesPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'p-6 text-white', children: [
      // Page Header
      Div(
          className: 'flex items-center justify-between mb-6',
          children: [
            H1(
                className: 'text-2xl font-bold text-white',
                child: Text('Licenses')),
            Button(
                className:
                    'px-4 py-2 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                attributes: {'id': 'create-license-btn'},
                child: Text('+ Create License')),
          ]),

      // Create License Panel (hidden by default)
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
                  Div(
                      className:
                          'grid grid-cols-1 md:grid-cols-2 gap-4',
                      children: [
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
                                    attributes: {'value': 'trial'},
                                    child: Text('Trial (14 days)')),
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
                                'placeholder': '1',
                                'value': '1',
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
                                'placeholder':
                                    'Optional notes about this license...',
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
                      child: Text('Expires')),
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
                      attributes: {'colspan': '8'},
                      child: Text('Loading licenses...')),
                ]),
              ]),
            ]),
          ]),

      // Deployments Panel (hidden by default)
      Div(
          id: 'deployments-panel',
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
                            Tr(
                                className: 'border-b border-white/10',
                                children: [
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('Machine')),
                                  Th(
                                      className:
                                          'text-left px-4 py-3 text-gray-400 font-medium text-xs uppercase tracking-wider',
                                      child: Text('Domain')),
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
                                  attributes: {'colspan': '7'},
                                  child: Text(
                                      'Select a license to view deployments')),
                            ]),
                          ]),
                        ]),
                      ]),
                ]),
          ]),

      // Page Script
      script(content: '''
(function() {
  var currentLicenseId = null;

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

  // Plan presets
  var planDefaults = {
    trial: { max: 1, days: 14 },
    personal: { max: 1, days: 0 },
    business: { max: 5, days: 0 },
    enterprise: { max: 999, days: 0 }
  };

  // Auto-fill defaults when plan changes
  var planSelect = document.getElementById('create-plan');
  if (planSelect) {
    planSelect.addEventListener('change', function() {
      var plan = this.value;
      var defaults = planDefaults[plan] || {};
      document.getElementById('create-max-deployments').value = defaults.max || 1;
      var expiresInput = document.getElementById('create-expires-at');
      if (defaults.days > 0) {
        var d = new Date();
        d.setDate(d.getDate() + defaults.days);
        expiresInput.value = d.toISOString().split('T')[0];
      } else {
        expiresInput.value = '';
      }
    });
  }

  function loadLicenses() {
    var tbody = document.getElementById('licenses-tbody');
    tbody.innerHTML = '<tr><td colspan="8" class="px-6 py-8 text-center text-gray-500">Loading licenses...</td></tr>';

    adminFetch('/api/admin/licenses').then(function(res) {
      if (!res.ok) throw new Error('Failed');
      return res.json();
    }).then(function(data) {
      var licenses = data.licenses || [];
      tbody.innerHTML = '';

      if (licenses.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="px-6 py-8 text-center text-gray-500">No licenses found.</td></tr>';
        return;
      }

      licenses.forEach(function(lic) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02] transition-colors';

        var isActive = lic.is_active;
        var statusClass = isActive ? 'bg-green-500/10 text-green-400' : 'bg-red-500/10 text-red-400';
        var statusText = isActive ? 'Active' : 'Inactive';
        var toggleText = isActive ? 'Deactivate' : 'Activate';
        var toggleClass = isActive ? 'bg-red-500/10 text-red-400 hover:bg-red-500/20' : 'bg-green-500/10 text-green-400 hover:bg-green-500/20';
        var created = lic.created_at ? new Date(lic.created_at).toLocaleDateString() : (lic.createdAt ? new Date(lic.createdAt).toLocaleDateString() : 'N/A');
        var expires = lic.expires_at ? new Date(lic.expires_at).toLocaleDateString() : 'Never';
        var keyShort = (lic.license_key || '').length > 20 ? (lic.license_key || '').substring(0, 20) + '...' : (lic.license_key || '');
        var userEmail = lic.user_email || lic.email || 'N/A';
        var planClass = lic.plan === 'trial' ? 'bg-yellow-500/10 text-yellow-400' : 'bg-primary-500/10 text-primary-400';

        row.innerHTML = '' +
          '<td class="px-6 py-4"><code class="text-xs font-mono text-gray-300 bg-white/5 px-2 py-1 rounded cursor-pointer" title="' + (lic.license_key || '') + '" onclick="navigator.clipboard.writeText(\\'' + (lic.license_key || '').replace(/'/g, "\\\\'") + '\\')">' + keyShort + '</code></td>' +
          '<td class="px-6 py-4"><span class="text-xs font-semibold px-2 py-0.5 rounded-full ' + planClass + ' uppercase">' + (lic.plan || 'N/A') + '</span></td>' +
          '<td class="px-6 py-4 text-gray-300 text-sm">' + userEmail + '</td>' +
          '<td class="px-6 py-4 text-gray-300 text-sm text-center">' + (lic.max_deployments != null ? lic.max_deployments : 'N/A') + '</td>' +
          '<td class="px-6 py-4"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span></td>' +
          '<td class="px-6 py-4 text-gray-400 text-sm">' + expires + '</td>' +
          '<td class="px-6 py-4 text-gray-400 text-sm">' + created + '</td>' +
          '<td class="px-6 py-4"><div class="flex gap-2">' +
            '<button class="toggle-license-btn text-xs px-3 py-1 rounded-lg font-medium transition-colors ' + toggleClass + '" data-id="' + (lic.id || '') + '" data-active="' + (isActive ? '1' : '0') + '">' + toggleText + '</button>' +
            '<button class="view-deployments-btn text-xs px-3 py-1 rounded-lg font-medium bg-primary-500/10 text-primary-400 hover:bg-primary-500/20 transition-colors" data-id="' + (lic.id || '') + '" data-key="' + (lic.license_key || '') + '">View</button>' +
          '</div></td>';

        tbody.appendChild(row);
      });

      // Toggle license events
      document.querySelectorAll('.toggle-license-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
          var licId = this.dataset.id;
          var newStatus = this.dataset.active !== '1';
          toggleLicense(licId, newStatus);
        });
      });

      // View deployments events
      document.querySelectorAll('.view-deployments-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
          showDeploymentsPanel(this.dataset.id, this.dataset.key);
        });
      });
    }).catch(function(err) {
      tbody.innerHTML = '<tr><td colspan="8" class="px-6 py-8 text-center text-red-400">Failed to load licenses.</td></tr>';
    });
  }

  function toggleLicense(licenseId, setActive) {
    adminFetch('/api/admin/licenses?id=' + licenseId, {
      method: 'PUT',
      body: { is_active: setActive }
    }).then(function(res) {
      if (!res.ok) throw new Error('Failed');
      loadLicenses();
    }).catch(function(err) {
      alert('Error toggling license: ' + err.message);
    });
  }

  function createLicense() {
    var email = document.getElementById('create-user-email').value.trim();
    var plan = document.getElementById('create-plan').value;
    var maxDeploy = parseInt(document.getElementById('create-max-deployments').value, 10) || 1;
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
      if (!res.ok) return res.json().then(function(d) { throw new Error(d.error || 'Failed'); });
      return res.json();
    }).then(function(data) {
      document.getElementById('create-user-email').value = '';
      document.getElementById('create-plan').value = 'trial';
      document.getElementById('create-max-deployments').value = '1';
      document.getElementById('create-notes').value = '';
      document.getElementById('create-expires-at').value = '';
      document.getElementById('create-license-panel').classList.add('hidden');
      loadLicenses();
      alert('License created: ' + (data.license ? data.license.license_key : 'Success'));
    }).catch(function(err) {
      alert('Error: ' + err.message);
    });
  }

  function showDeploymentsPanel(licenseId, licenseKey) {
    currentLicenseId = licenseId;
    document.getElementById('deployments-panel').classList.remove('hidden');
    document.getElementById('deployments-license-info').textContent = 'License: ' + (licenseKey || licenseId);
    loadDeployments(licenseId);
    document.getElementById('deployments-panel').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function loadDeployments(licenseId) {
    var tbody = document.getElementById('deployments-tbody');
    tbody.innerHTML = '<tr><td colspan="7" class="px-4 py-8 text-center text-gray-500">Loading...</td></tr>';

    adminFetch('/api/admin/deployments?license_id=' + licenseId).then(function(res) {
      if (!res.ok) throw new Error('Failed');
      return res.json();
    }).then(function(data) {
      var deps = data.deployments || [];
      tbody.innerHTML = '';

      if (deps.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="px-4 py-8 text-center text-gray-500">No deployments.</td></tr>';
        return;
      }

      deps.forEach(function(dep) {
        var row = document.createElement('tr');
        row.className = 'border-b border-white/5 hover:bg-white/[0.02]';
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
          '<td class="px-4 py-3"><span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span></td>' +
          '<td class="px-4 py-3">' +
            (isActive ? '<button class="deactivate-deploy-btn text-xs px-3 py-1 rounded-lg font-medium bg-red-500/10 text-red-400 hover:bg-red-500/20 transition-colors" data-id="' + (dep.id || '') + '">Deactivate</button>' : '<span class="text-gray-600 text-xs">--</span>') +
          '</td>';

        tbody.appendChild(row);
      });

      document.querySelectorAll('.deactivate-deploy-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
          if (!confirm('Deactivate this deployment?')) return;
          adminFetch('/api/admin/deployments?id=' + this.dataset.id, { method: 'DELETE' }).then(function(res) {
            if (!res.ok) throw new Error('Failed');
            if (currentLicenseId) loadDeployments(currentLicenseId);
          });
        });
      });
    }).catch(function(err) {
      tbody.innerHTML = '<tr><td colspan="7" class="px-4 py-8 text-center text-red-400">Failed to load deployments.</td></tr>';
    });
  }

  // Event listeners
  var createBtn = document.getElementById('create-license-btn');
  if (createBtn) {
    createBtn.addEventListener('click', function() {
      document.getElementById('create-license-panel').classList.toggle('hidden');
    });
  }

  var closeCreateBtn = document.getElementById('close-create-panel');
  if (closeCreateBtn) {
    closeCreateBtn.addEventListener('click', function() {
      document.getElementById('create-license-panel').classList.add('hidden');
    });
  }

  var submitCreateBtn = document.getElementById('submit-create-license');
  if (submitCreateBtn) {
    submitCreateBtn.addEventListener('click', createLicense);
  }

  var closeDeploymentsBtn = document.getElementById('close-deployments-panel');
  if (closeDeploymentsBtn) {
    closeDeploymentsBtn.addEventListener('click', function() {
      document.getElementById('deployments-panel').classList.add('hidden');
      currentLicenseId = null;
    });
  }

  loadLicenses();
})();
      '''),
    ]);
  }
}
