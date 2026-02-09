import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class DashboardLayout extends StatelessComponent {
  final Component child;
  const DashboardLayout({super.key, required this.child});

  @override
  Component build(BuildContext context) {
    return Div(className: 'min-h-screen bg-[#141414] flex', children: [
      // Sidebar
      Aside(className: 'hidden lg:flex lg:flex-col w-64 bg-[#1a1a1a] border-r border-white/10', children: [
        Div(className: 'h-16 flex items-center px-6 border-b border-white/10', children: [
          Link(to: '/', child:
            Img(src: '/logo.svg', alt: 'Omnius', className: 'h-6'),
          ),
        ]),
        Nav(className: 'flex-1 px-4 py-6 space-y-1', children: [
          Link(to: '/app', child: Div(className: 'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-300 hover:text-white hover:bg-white/5 transition-colors', children: [
            Span(child: Text('\u{1f4cb}')), Span(child: Text('Dashboard')),
          ])),
          Link(to: '/pricing', child: Div(className: 'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-300 hover:text-white hover:bg-white/5 transition-colors', children: [
            Span(child: Text('\u{1f4b3}')), Span(child: Text('Buy License')),
          ])),
          Link(to: '/app/setup', child: Div(className: 'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-300 hover:text-white hover:bg-white/5 transition-colors', children: [
            Span(child: Text('\u{1f4d6}')), Span(child: Text('Setup Guide')),
          ])),
        ]),
        Div(className: 'px-4 py-4 border-t border-white/10', children: [
          A(href: '/api/auth/logout', className: 'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-gray-400 hover:text-red-400 hover:bg-red-500/10 transition-colors', children: [
            Span(child: Text('\u{1f6aa}')), Span(child: Text('Logout')),
          ]),
        ]),
      ]),
      // Main content
      Div(className: 'flex-1 flex flex-col', children: [
        Header(className: 'h-16 bg-[#1a1a1a] border-b border-white/10 flex items-center justify-between px-6', children: [
          H2(className: 'text-lg font-semibold text-white', child: Text('Dashboard')),
          A(href: '/api/auth/logout', className: 'text-sm text-gray-400 hover:text-white transition-colors', child: Text('Sign Out')),
        ]),
        Main(className: 'flex-1 p-6 overflow-auto', child: child),
      ]),
    ]);
  }
}
