import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class FeaturesPage extends StatelessComponent {
  const FeaturesPage({super.key});

  static const _features = [
    {
      'icon': '\u{1f4fa}',
      'title': 'TV-Optimized UI',
      'desc':
          'Built with Jetpack Compose for Android TV. Smooth animations, large thumbnails, and an interface designed for big screens.',
    },
    {
      'icon': '\u{1f3ae}',
      'title': 'D-pad Navigation',
      'desc':
          'Full remote control support. Navigate movies, shows, and settings with your Android TV remote — no touch required.',
    },
    {
      'icon': '\u{25b6}\u{fe0f}',
      'title': 'In-App Player',
      'desc':
          'ExoPlayer with HLS, DASH, and adaptive streaming. Subtitles, quality selection, and resume playback built in.',
    },
    {
      'icon': '\u{1f30d}',
      'title': 'Subtitles (60+ Languages)',
      'desc':
          'SubDL integration fetches subtitles automatically. Supports 60+ languages with customizable appearance.',
    },
    {
      'icon': '\u{23f8}\u{fe0f}',
      'title': 'Continue Watching',
      'desc':
          'Automatic progress tracking. Pick up right where you left off across app restarts and sessions.',
    },
    {
      'icon': '\u{2764}\u{fe0f}',
      'title': 'Favorites',
      'desc':
          'Save movies and shows to your favorites list. Persistent across app restarts with quick access.',
    },
    {
      'icon': '\u{1f50d}',
      'title': 'Search & Browse',
      'desc':
          'Browse by genre, rating, year, or search directly. Infinite scroll keeps content loading as you explore.',
    },
    {
      'icon': '\u{1f3ac}',
      'title': 'Series & Episodes',
      'desc':
          'Full season and episode support with automatic next-episode queuing and series-level progress tracking.',
    },
    {
      'icon': '\u{1f517}',
      'title': 'P2P Streaming',
      'desc':
          'Peer-to-peer distribution enables efficient content delivery at scale. Reduce bandwidth costs with distributed streaming.',
    },
    {
      'icon': '\u{2699}\u{fe0f}',
      'title': 'Configurable Server',
      'desc':
          'Point the app at any server URL. Switch between instances or run multiple deployments from one license.',
    },
    {
      'icon': '\u{1f4ca}',
      'title': 'Watch History',
      'desc':
          'Automatic tracking of everything watched with progress bars showing completion percentage.',
    },
  ];

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-16 text-center px-4', children: [
        Div(className: 'max-w-3xl mx-auto', children: [
          H1(className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Everything Your Users Expect')),
          P(className: 'text-xl text-gray-400 mb-8',
              child: Text(
                  '12 core features that make Omnius a complete streaming platform, ready out of the box.')),
          Div(className: 'flex justify-center gap-4', children: [
            Link(
              to: '/pricing',
              child: Span(
                  className:
                      'px-6 py-3 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                  child: Text('Get Started')),
            ),
            A(
              href: 'mailto:hello@omnius.stream',
              className:
                  'px-6 py-3 border border-white/20 text-white font-semibold rounded-lg hover:bg-white/5 transition-colors',
              child: Text('Contact Us'),
            ),
          ]),
        ]),
      ]),

      // Features Grid
      Section(className: 'py-16', children: [
        Div(className: 'max-w-6xl mx-auto px-4', children: [
          Div(className: 'grid md:grid-cols-3 gap-6', children: [
            for (final feature in _features)
              Div(
                  className:
                      'p-6 rounded-xl bg-white/5 border border-white/10 hover:border-primary-500/30 transition-all hover:bg-white/[0.07]',
                  children: [
                    Div(className: 'text-3xl mb-4',
                        child: Text(feature['icon']!)),
                    H3(className: 'text-lg font-semibold text-white mb-2',
                        child: Text(feature['title']!)),
                    P(className: 'text-sm text-gray-400 leading-relaxed',
                        child: Text(feature['desc']!)),
                  ]),
          ]),
        ]),
      ]),

      // CTA
      Section(className: 'py-20 text-center', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(className: 'text-3xl font-bold text-white mb-4',
              child: Text('Ready to Get Started?')),
          P(className: 'text-gray-400 mb-8',
              child: Text(
                  'One-time purchase, deploy in minutes, full control of your platform.')),
          Link(
            to: '/pricing',
            child: Span(
                className:
                    'inline-block px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                child: Text('View Pricing \u2192')),
          ),
        ]),
      ]),
    ]);
  }
}
