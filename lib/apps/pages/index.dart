import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class AppsPage extends StatelessComponent {
  const AppsPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'apps-bg', children: [
      // Hero
      Section(className: 'pt-24 pb-16 text-center px-4', children: [
        Div(className: 'max-w-4xl mx-auto', children: [
          H1(
              className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Omnius Apps')),
          P(
              className: 'text-xl text-gray-400',
              child: Text(
                  'Watch on any device. All apps are free.')),
        ]),
      ]),

      // Smart TVs
      _section('Smart TVs', [
        _deviceCard(name: 'Samsung TV', icon: '/icons/samsung.svg', status: 'in_review'),
        _deviceCard(name: 'LG TV', icon: '/icons/lg.svg', status: 'in_review'),
        _deviceCard(name: 'Android TV', icon: '/icons/google_tv.svg', status: 'available', downloadUrl: 'https://github.com/OmniusRepos/omnius-releases/releases/latest/download/omnius-tv.apk'),
        _deviceCard(name: 'Android TV (Light)', icon: '/icons/google_tv.svg', status: 'available', note: 'Low-RAM build for 1 GB / Android 9 boxes', downloadUrl: 'https://github.com/OmniusRepos/omnius-releases/releases/download/omnius-light/omnius-light.apk'),
      ]),

      // Streaming Boxes
      _section('Streaming Boxes', [
        _deviceCard(name: 'Amazon Fire TV', icon: '/icons/fire-tv.svg', status: 'coming_soon'),
        _deviceCard(name: 'Apple TV', icon: '/icons/Apple_TV_logo.svg', status: 'coming_soon'),
        _deviceCard(name: 'Roku', icon: '/icons/roku.svg', status: 'coming_soon'),
      ]),

      // Mobile
      _section('Mobile', [
        _deviceCard(name: 'iOS & iPad', icon: '/icons/ios.svg', status: 'coming_soon'),
        _deviceCard(name: 'Android Phone', icon: '/icons/Android.svg', status: 'coming_soon'),
      ]),

      // Desktop
      _section('Desktop', [
        _deviceCard(name: 'macOS', icon: '/icons/macos.svg', status: 'coming_soon'),
      ]),

      // Looking for Server?
      Section(className: 'py-20 text-center border-t border-white/5', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(
              className: 'text-3xl font-bold text-white mb-4',
              child: Text('Looking for Server?')),
          P(
              className: 'text-gray-400 mb-8',
              child: Text(
                  'Apps connect to your self-hosted Omnius server. Deploy with Docker in minutes.')),
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

  Component _section(String title, List<Component> cards) {
    return Section(className: 'py-12', children: [
      Div(className: 'max-w-6xl mx-auto px-4', children: [
        H2(className: 'text-2xl font-bold text-white mb-8', child: Text(title)),
        Div(className: 'grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5', children: cards),
      ]),
    ]);
  }

  Component _deviceCard({
    required String name,
    required String icon,
    required String status,
    String? downloadUrl,
    String? note,
  }) {
    final isAvailable = status == 'available';
    final isReview = status == 'in_review';

    final badgeText = isAvailable
        ? 'Available'
        : isReview
            ? 'In Review'
            : 'Coming Soon';
    final badgeClass = isAvailable
        ? 'text-xs px-2.5 py-1 rounded-full font-medium bg-green-500/20 text-green-400'
        : isReview
            ? 'text-xs px-2.5 py-1 rounded-full font-medium bg-yellow-500/20 text-yellow-400'
            : 'text-xs px-2.5 py-1 rounded-full font-medium bg-white/10 text-gray-500';

    final card = Div(
        className: 'app-card rounded-2xl p-8 flex flex-col items-center text-center group cursor-pointer',
        children: [
          Div(className: 'mb-5', children: [
            Img(src: icon, alt: name, className: 'app-icon w-20 h-20 object-contain'),
          ]),
          H3(className: 'text-lg font-bold text-white mb-2', child: Text(name)),
          Span(className: badgeClass, child: Text(badgeText)),
          if (note != null)
            P(className: 'text-xs text-gray-500 mt-3', child: Text(note)),
          if (downloadUrl != null)
            A(href: downloadUrl, attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
              className: 'mt-4 px-5 py-2 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors',
              child: Text('Download APK')),
        ]);

    return card;
  }
}
