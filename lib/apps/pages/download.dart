import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class AppsDownloadPage extends StatelessComponent {
  const AppsDownloadPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-4xl mx-auto', children: [
          H1(
              className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Download Omnius')),
          P(
              className: 'text-xl text-gray-400 mb-2',
              child: Text(
                  'Get the free app for your platform.')),
        ]),
      ]),

      // Available Now
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-8', child: Text('Available Now')),
          Div(className: 'space-y-4', children: [
            _downloadRow(
              name: 'Android TV',
              icon: '\ud83d\udcf1',
              description: 'Google Play Store',
              url: 'https://play.google.com/store/apps/details?id=lol.omnius.tv',
              buttonText: 'Get on Google Play',
            ),
            _downloadRow(
              name: 'macOS',
              icon: '\ud83d\udcbb',
              description: 'Direct download (.dmg) — macOS 12+',
              url: 'https://github.com/AmbrosLabs/omnius_releases/releases',
              buttonText: 'Download for macOS',
            ),
          ]),
        ]),
      ]),

      // In Review
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-8', child: Text('In Review')),
          P(className: 'text-gray-400 mb-6',
              child: Text('These apps are submitted and awaiting store approval.')),
          Div(className: 'space-y-4', children: [
            _pendingRow(
              name: 'LG webOS',
              icon: '\ud83d\udcfa',
              description: 'LG Content Store — submitted for review',
            ),
            _pendingRow(
              name: 'Samsung Tizen',
              icon: '\ud83d\udcfa',
              description: 'Samsung TV Apps — submitted for review',
            ),
          ]),
        ]),
      ]),

      // Coming Soon
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-8', child: Text('Coming Soon')),
          Div(className: 'space-y-4', children: [
            _pendingRow(
              name: 'iOS',
              icon: '\ud83d\udcf1',
              description: 'App Store — in development',
            ),
            _pendingRow(
              name: 'Web Player',
              icon: '\ud83c\udf10',
              description: 'Browser-based player — in development',
            ),
          ]),
        ]),
      ]),

      // Looking for Server?
      Section(className: 'py-20 text-center bg-[#141414]', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(
              className: 'text-3xl font-bold text-white mb-4',
              child: Text('Looking for Server?')),
          P(
              className: 'text-gray-400 mb-8',
              child: Text(
                  'Deploy your own Omnius streaming server with Docker. One-time purchase, no subscriptions.')),
          Link(
            to: '/server',
            child: Span(
                className: 'px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                child: Text('Server Setup \u2192')),
          ),
        ]),
      ]),
    ]);
  }

  Component _downloadRow({
    required String name,
    required String icon,
    required String description,
    required String url,
    required String buttonText,
  }) {
    return Div(
        className: 'p-6 rounded-xl bg-primary-500/5 border border-primary-500/20 flex flex-col md:flex-row md:items-center justify-between gap-4',
        children: [
          Div(className: 'flex items-center gap-4', children: [
            Span(className: 'text-3xl', child: Text(icon)),
            Div(children: [
              H3(className: 'text-lg font-bold text-white', child: Text(name)),
              P(className: 'text-sm text-gray-400', child: Text(description)),
            ]),
          ]),
          A(
              href: url,
              className: 'px-6 py-2.5 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors text-center',
              attributes: {'target': '_blank', 'rel': 'noopener'},
              child: Text(buttonText)),
        ]);
  }

  Component _pendingRow({
    required String name,
    required String icon,
    required String description,
  }) {
    return Div(
        className: 'p-6 rounded-xl bg-white/5 border border-white/10 flex items-center gap-4',
        children: [
          Span(className: 'text-3xl', child: Text(icon)),
          Div(children: [
            H3(className: 'text-lg font-bold text-white', child: Text(name)),
            P(className: 'text-sm text-gray-400', child: Text(description)),
          ]),
        ]);
  }
}
