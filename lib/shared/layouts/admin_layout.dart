import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import 'package:jaspr_router/jaspr_router.dart';

class AdminLayout extends StatelessComponent {
  final Component child;
  const AdminLayout({super.key, required this.child});

  @override
  Component build(BuildContext context) {
    return Div(className: 'min-h-screen bg-[#141414] flex', children: [
      // Sidebar
      Aside(
          id: 'admin-sidebar',
          className:
              'hidden lg:flex lg:flex-col w-64 bg-[#1a1a1a] border-r border-white/10',
          children: [
            // Logo
            Div(
                className:
                    'h-16 flex items-center px-6 border-b border-white/10',
                children: [
                  Link(
                    to: '/',
                    child: Div(
                        className: 'flex items-center gap-3',
                        children: [
                          Img(
                              src: '/logo.svg',
                              alt: 'Omnius',
                              className: 'h-6'),
                          Span(
                              className:
                                  'text-xs font-medium text-gray-500 uppercase tracking-wider',
                              child: Text('Admin')),
                        ]),
                  ),
                ]),
            // Navigation
            Nav(
                className: 'flex-1 px-4 py-6 space-y-1',
                children: [
                  Link(
                      to: '/admin/customers',
                      child: Div(
                          className:
                              'admin-nav-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-300 hover:text-white hover:bg-white/5 transition-colors',
                          attributes: {'data-page': 'customers'},
                          children: [
                            Span(
                                className: 'text-base',
                                child: Text('\u{1f465}')),
                            Span(child: Text('Customers')),
                          ])),
                  Link(
                      to: '/admin/licenses',
                      child: Div(
                          className:
                              'admin-nav-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-300 hover:text-white hover:bg-white/5 transition-colors',
                          attributes: {'data-page': 'licenses'},
                          children: [
                            Span(
                                className: 'text-base',
                                child: Text('\u{1f511}')),
                            Span(child: Text('Licenses')),
                          ])),
                  Link(
                      to: '/admin/orders',
                      child: Div(
                          className:
                              'admin-nav-link flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-300 hover:text-white hover:bg-white/5 transition-colors',
                          attributes: {'data-page': 'orders'},
                          children: [
                            Span(
                                className: 'text-base',
                                child: Text('\u{1f4b3}')),
                            Span(child: Text('Orders')),
                          ])),
                ]),
            // Logout
            Div(
                className: 'px-4 py-4 border-t border-white/10',
                children: [
                  Button(
                      className:
                          'admin-logout-btn w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-400 hover:text-red-400 hover:bg-red-500/10 transition-colors',
                      children: [
                        Span(child: Text('\u{1f6aa}')),
                        Span(child: Text('Logout')),
                      ]),
                ]),
          ]),
      // Main content
      Div(className: 'flex-1 flex flex-col', children: [
        Main(className: 'flex-1 overflow-auto', child: child),
      ]),

      // Auth check + sidebar active state + logout script
      script(content: '''
(function() {
  // Auth check: if not authenticated, redirect to login
  fetch('/api/admin/stats', { credentials: 'same-origin' }).then(function(res) {
    if (!res.ok) {
      window.location.href = '/admin';
    }
  }).catch(function() {
    window.location.href = '/admin';
  });

  // Highlight active nav link based on current path
  var path = window.location.pathname;
  document.querySelectorAll('.admin-nav-link').forEach(function(link) {
    var page = link.dataset.page;
    if (path.indexOf('/admin/' + page) === 0) {
      link.classList.add('bg-white/5', 'text-white');
      link.classList.remove('text-gray-300');
    }
  });

  // Logout handler
  var logoutBtn = document.querySelector('.admin-logout-btn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', function() {
      fetch('/api/admin/logout', {
        method: 'POST',
        credentials: 'same-origin'
      }).finally(function() {
        window.location.href = '/admin';
      });
    });
  }
})();
      '''),
    ]);
  }
}
