import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class SiteHeader extends StatelessComponent {
  const SiteHeader({super.key});

  @override
  Component build(BuildContext context) {
    return Header(
      className: 'fixed top-0 left-0 right-0 z-50 bg-[#141414]/90 backdrop-blur-md border-b border-white/10',
      child: Div(className: 'max-w-7xl mx-auto px-4 sm:px-6 lg:px-8', child:
        Div(className: 'flex h-16 items-center justify-between', children: [
          Link(to: '/', child:
            Div(className: 'flex items-center gap-2', children: [
              Span(className: 'text-2xl font-bold text-primary-500', child: Text('O')),
              Span(className: 'text-lg font-semibold text-white', child: Text('mnius')),
            ]),
          ),
          Nav(className: 'hidden md:flex items-center gap-6', children: [
            Link(to: '/features', child: Span(className: 'text-sm text-gray-400 hover:text-white transition-colors', child: Text('Features'))),
            Link(to: '/pricing', child: Span(className: 'text-sm text-gray-400 hover:text-white transition-colors', child: Text('Pricing'))),
            Link(to: '/setup', child: Span(className: 'text-sm text-gray-400 hover:text-white transition-colors', child: Text('Setup'))),
            Link(to: '/auth/login', child: Span(className: 'text-sm text-gray-400 hover:text-white transition-colors', child: Text('Login'))),
            A(href: 'mailto:hello@omnius.stream',
              className: 'px-4 py-2 bg-primary-500 text-white text-sm font-medium rounded-lg hover:bg-primary-600 transition-colors',
              child: Text('Contact Us')),
          ]),
        ]),
      ),
    );
  }
}
