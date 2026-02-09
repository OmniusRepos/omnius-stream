import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return Footer(
      className: 'border-t border-white/10 py-8 mt-auto',
      child: Div(
        className: 'max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-4',
        children: [
          P(className: 'text-sm text-gray-500', child: Text('Omnius \u00a9 2026. All rights reserved.')),
          Div(className: 'flex items-center gap-6', children: [
            Link(to: '/terms', child: Span(className: 'text-sm text-gray-500 hover:text-gray-300 transition-colors', child: Text('Terms'))),
            Link(to: '/privacy', child: Span(className: 'text-sm text-gray-500 hover:text-gray-300 transition-colors', child: Text('Privacy'))),
            Link(to: '/refund', child: Span(className: 'text-sm text-gray-500 hover:text-gray-300 transition-colors', child: Text('Refund'))),
            A(href: 'mailto:hello@omnius.stream', className: 'text-sm text-gray-500 hover:text-gray-300 transition-colors', child: Text('hello@omnius.stream')),
          ]),
        ],
      ),
    );
  }
}
