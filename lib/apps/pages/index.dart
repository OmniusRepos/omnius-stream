import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class AppsPage extends StatelessComponent {
  const AppsPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-4xl mx-auto', children: [
          H1(
              className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Omnius Apps')),
          P(
              className: 'text-xl text-gray-400 mb-2',
              child: Text(
                  'Native apps for your TV, desktop, and mobile.')),
          P(
              className: 'text-lg text-green-400 font-medium',
              child: Text('All apps are free.')),
        ]),
      ]),

      // TV Apps
      Section(className: 'py-12', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6', child: Text('Smart TV')),
          Div(className: 'grid md:grid-cols-2 lg:grid-cols-3 gap-6', children: [
            _platformCard(
              name: 'LG webOS',
              icon: '\ud83d\udcfa',
              store: 'LG Content Store',
              status: 'in_review',
            ),
            _platformCard(
              name: 'Samsung Tizen',
              icon: '\ud83d\udcfa',
              store: 'Samsung TV Apps',
              status: 'in_review',
            ),
            _platformCard(
              name: 'Android TV',
              icon: '\ud83d\udcf1',
              store: 'Google Play',
              status: 'available',
            ),
          ]),
        ]),
      ]),

      // Desktop & Mobile
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6', child: Text('Desktop & Mobile')),
          Div(className: 'grid md:grid-cols-2 lg:grid-cols-3 gap-6', children: [
            _platformCard(
              name: 'macOS',
              icon: '\ud83d\udcbb',
              store: 'Direct Download',
              status: 'available',
            ),
            _platformCard(
              name: 'iOS',
              icon: '\ud83d\udcf1',
              store: 'App Store',
              status: 'coming_soon',
            ),
            _platformCard(
              name: 'Web Player',
              icon: '\ud83c\udf10',
              store: 'Browser',
              status: 'coming_soon',
            ),
          ]),
        ]),
      ]),

      // How It Works
      Section(className: 'py-16', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('How It Works')),
          Div(className: 'grid md:grid-cols-3 gap-8', children: [
            _step('1', 'Deploy Server', 'Set up your Omnius server with Docker in minutes.'),
            _step('2', 'Install App', 'Download the free app on your device.'),
            _step('3', 'Connect', 'Enter your server URL and start streaming.'),
          ]),
        ]),
      ]),

      // CTA
      Section(className: 'py-20 text-center', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(
              className: 'text-3xl font-bold text-white mb-4',
              child: Text('Need a Server?')),
          P(
              className: 'text-gray-400 mb-8',
              child: Text(
                  'Apps connect to your self-hosted Omnius server. Deploy with Docker in minutes.')),
          Div(className: 'flex justify-center gap-4 flex-wrap', children: [
            Link(
              to: '/apps/download',
              child: Span(
                  className: 'px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                  child: Text('Download Apps \u2192')),
            ),
            Link(
              to: '/server',
              child: Span(
                  className: 'px-8 py-3.5 border border-white/20 text-white font-semibold rounded-lg hover:bg-white/5 transition-colors',
                  child: Text('Server Setup')),
            ),
          ]),
        ]),
      ]),
    ]);
  }

  Component _platformCard({
    required String name,
    required String icon,
    required String store,
    required String status,
  }) {
    final isAvailable = status == 'available';
    final isReview = status == 'in_review';

    final badgeClass = isAvailable
        ? 'bg-green-500/20 text-green-400'
        : isReview
            ? 'bg-yellow-500/20 text-yellow-400'
            : 'bg-white/10 text-gray-400';
    final badgeText = isAvailable
        ? 'Available'
        : isReview
            ? 'In Review'
            : 'Coming Soon';

    return Div(
        className: isAvailable
            ? 'p-6 rounded-xl bg-primary-500/5 border border-primary-500/20 hover:border-primary-500/40 transition-colors'
            : 'p-6 rounded-xl bg-white/5 border border-white/10',
        children: [
          Div(className: 'flex items-center justify-between mb-4', children: [
            Span(className: 'text-3xl', child: Text(icon)),
            Span(
                className: 'text-xs px-2.5 py-1 rounded-full font-medium $badgeClass',
                child: Text(badgeText)),
          ]),
          H3(className: 'text-lg font-bold text-white mb-1', child: Text(name)),
          P(className: 'text-sm text-gray-400 mb-1', child: Text(store)),
          P(className: 'text-xs text-green-400/80', child: Text('Free')),
        ]);
  }

  Component _step(String number, String title, String desc) {
    return Div(className: 'text-center', children: [
      Div(
          className: 'w-10 h-10 rounded-full bg-primary-500/10 flex items-center justify-center mx-auto mb-3',
          child: Span(className: 'text-primary-500 font-bold', child: Text(number))),
      H3(className: 'text-lg font-semibold text-white mb-2', child: Text(title)),
      P(className: 'text-sm text-gray-400', child: Text(desc)),
    ]);
  }
}
