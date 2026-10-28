import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;

class AppDashboardPage extends StatelessComponent {
  const AppDashboardPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Page header
      Div(className: 'flex items-center justify-between mb-8', children: [
        Div(children: [
          H1(className: 'text-2xl font-bold text-white',
              child: Text('My Licenses')),
          P(className: 'text-gray-400 text-sm mt-1',
              child: Text('Manage your Omnius license keys')),
        ]),
        A(
          href: 'mailto:hello@omnius.stream',
          className:
              'px-4 py-2 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors',
          child: Text('Request License'),
        ),
      ]),

      // Loading state
      Div(id: 'dashboard-loading', className: 'text-center py-16', children: [
        P(className: 'text-gray-400',
            child: Text('Loading your licenses...')),
      ]),

      // Empty state
      Div(
          id: 'dashboard-empty',
          className: 'hidden text-center py-16',
          children: [
            Div(
                className:
                    'inline-flex items-center justify-center w-20 h-20 rounded-full bg-white/5 mb-6',
                children: [
                  Span(className: 'text-4xl text-gray-600',
                      child: Text('\u{1f511}')),
                ]),
            H2(className: 'text-xl font-semibold text-white mb-2',
                child: Text('No Licenses Yet')),
            P(className: 'text-gray-400 mb-6',
                child:
                    Text('Contact us to get your first license key.')),
            A(
              href: 'mailto:hello@omnius.stream',
              className:
                  'inline-block px-6 py-3 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
              child: Text('Request License'),
            ),
          ]),

      // Licenses grid
      Div(
          id: 'licenses-grid',
          className: 'hidden grid md:grid-cols-2 gap-6 mb-12',
          children: []),

      // Orders section
      Div(id: 'orders-section', className: 'hidden mt-12', children: [
        H2(className: 'text-xl font-bold text-white mb-4',
            child: Text('Purchase History')),
        Div(
            className:
                'rounded-xl bg-[#1a1a1a] border border-white/10 overflow-hidden',
            children: [
              Table(className: 'w-full text-sm', children: [
                Thead(children: [
                  Tr(className: 'border-b border-white/10', children: [
                    Th(className:
                            'text-left px-6 py-3 text-gray-400 font-medium text-xs',
                        child: Text('Transaction')),
                    Th(className:
                            'text-left px-6 py-3 text-gray-400 font-medium text-xs',
                        child: Text('Amount')),
                    Th(className:
                            'text-left px-6 py-3 text-gray-400 font-medium text-xs',
                        child: Text('Status')),
                    Th(className:
                            'text-left px-6 py-3 text-gray-400 font-medium text-xs',
                        child: Text('Date')),
                  ]),
                ]),
                Tbody(id: 'orders-tbody', children: []),
              ]),
            ]),
      ]),

      // Dashboard script
      script(content: '''
(function() {
  async function loadDashboard() {
    try {
      const [licensesRes, ordersRes] = await Promise.all([
        fetch('/api/dashboard/licenses'),
        fetch('/api/dashboard/orders'),
      ]);

      const licensesData = await licensesRes.json();
      const ordersData = await ordersRes.json();

      document.getElementById('dashboard-loading').classList.add('hidden');

      const licenses = licensesData.licenses || [];
      const orders = ordersData.orders || [];

      if (licenses.length === 0) {
        document.getElementById('dashboard-empty').classList.remove('hidden');
        return;
      }

      var grid = document.getElementById('licenses-grid');
      grid.classList.remove('hidden');
      grid.innerHTML = '';

      licenses.forEach(function(lic) {
        var statusClass = lic.is_active ? 'bg-green-500/10 text-green-500' : 'bg-red-500/10 text-red-500';
        var statusText = lic.is_active ? 'Active' : 'Inactive';
        var created = lic.createdAt ? new Date(lic.createdAt).toLocaleDateString() : 'N/A';

        var card = document.createElement('div');
        card.className = 'p-6 rounded-xl bg-white/5 border border-white/10 hover:border-primary-500/20 transition-colors';
        card.innerHTML = '<div class="flex items-start justify-between mb-4">' +
          '<div><div class="flex items-center gap-2 mb-2">' +
          '<span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-primary-500/10 text-primary-500">' + (lic.plan || '').toUpperCase() + '</span>' +
          '<span class="text-xs font-medium px-2 py-0.5 rounded-full ' + statusClass + '">' + statusText + '</span>' +
          '</div><code class="text-sm font-mono text-white block">' + (lic.license_key || '') + '</code></div>' +
          '<button class="copy-btn px-3 py-1 bg-white/10 text-white text-xs rounded-lg hover:bg-white/20 transition-colors" data-key="' + (lic.license_key || '') + '">Copy</button></div>' +
          '<div class="grid grid-cols-2 gap-4 text-sm">' +
          '<div><span class="text-gray-500 block text-xs">Deployments</span><span class="text-gray-300">' + (lic.max_deployments || 0) + '</span></div>' +
          '<div><span class="text-gray-500 block text-xs">Created</span><span class="text-gray-300">' + created + '</span></div></div>';

        grid.appendChild(card);
      });

      document.querySelectorAll('.copy-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
          navigator.clipboard.writeText(this.dataset.key);
          this.textContent = 'Copied!';
          var b = this;
          setTimeout(function() { b.textContent = 'Copy'; }, 2000);
        });
      });

      if (orders.length > 0) {
        document.getElementById('orders-section').classList.remove('hidden');
        var tbody = document.getElementById('orders-tbody');
        tbody.innerHTML = '';
        orders.forEach(function(order) {
          var date = order.createdAt ? new Date(order.createdAt).toLocaleDateString() : 'N/A';
          var statusClass = order.status === 'completed' ? 'text-green-500' : 'text-red-500';
          var row = document.createElement('tr');
          row.className = 'border-b border-white/5';
          row.innerHTML = '<td class="px-6 py-3 text-gray-300 font-mono text-xs">' + (order.transaction_id || 'N/A') + '</td>' +
            '<td class="px-6 py-3 text-gray-300">' + (order.amount || '0') + ' ' + (order.currency || 'USD') + '</td>' +
            '<td class="px-6 py-3 ' + statusClass + ' font-medium capitalize">' + (order.status || 'unknown') + '</td>' +
            '<td class="px-6 py-3 text-gray-400">' + date + '</td>';
          tbody.appendChild(row);
        });
      }
    } catch (err) {
      document.getElementById('dashboard-loading').innerHTML = '<p class="text-red-400">Failed to load dashboard. Please <a href="/auth/login" class="underline">sign in</a>.</p>';
    }
  }

  loadDashboard();
})();
      '''),
    ]);
  }
}
