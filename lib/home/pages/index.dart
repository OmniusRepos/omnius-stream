import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import 'package:jaspr_router/jaspr_router.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero Section
      Section(
          className:
              'relative min-h-screen flex items-center justify-center overflow-hidden',
          children: [
            // Background gradient
            Div(
                className:
                    'absolute inset-0 bg-gradient-to-b from-primary-500/5 via-transparent to-transparent',
                children: []),
            Div(className: 'relative z-10 text-center px-4 max-w-5xl mx-auto', children: [
              Span(
                  className:
                      'inline-block px-4 py-1.5 mb-6 text-sm font-medium text-primary-500 bg-primary-500/10 rounded-full border border-primary-500/20',
                  child: Text('Self-Hosted Streaming Platform')),
              H1(className: 'text-5xl md:text-7xl font-extrabold text-white mb-6 leading-tight', children: [
                Text('Your Content.'),
                Br(),
                Span(className: 'text-primary-500', child: Text('Your Server.')),
                Br(),
                Text('Your Rules.'),
              ]),
              P(
                  className: 'text-xl text-gray-400 mb-10 max-w-2xl mx-auto',
                  child: Text(
                      'Deploy your own streaming platform with Android TV app, admin panel, and media server. One license, full control.')),
              Div(className: 'flex flex-col sm:flex-row justify-center gap-4', children: [
                Link(
                  to: '/pricing',
                  child: Span(
                      className:
                          'px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors text-lg',
                      child: Text('Get Started \u2192')),
                ),
                Link(
                  to: '/features',
                  child: Span(
                      className:
                          'px-8 py-3.5 border border-white/20 text-white font-semibold rounded-lg hover:bg-white/5 transition-colors text-lg',
                      child: Text('See Features')),
                ),
              ]),
            ]),
          ]),

      // Stats Section
      Section(className: 'py-16 border-y border-white/5', children: [
        Div(
            className:
                'max-w-5xl mx-auto px-4 grid grid-cols-2 md:grid-cols-4 gap-8',
            children: [
              _statItem('12+', 'Core Features'),
              _statItem('60+', 'Subtitle Languages'),
              _statItem('2', 'Platforms'),
              _statItem('\$99', 'Starting Price'),
            ]),
      ]),

      // Screenshots Section
      Section(className: 'py-20', children: [
        Div(className: 'max-w-6xl mx-auto px-4', children: [
          Div(className: 'text-center mb-12', children: [
            H2(className: 'text-3xl font-bold text-white mb-4',
                child: Text('Beautiful on Every Screen')),
            P(className: 'text-gray-400 max-w-xl mx-auto',
                child: Text(
                    'From Android TV to the admin panel, every interface is crafted for the best experience.')),
          ]),
          Div(className: 'grid md:grid-cols-3 gap-6', children: [
            _screenshot('/screenshots/home.webp', 'TV Home Screen'),
            _screenshot('/screenshots/movie-details.webp', 'Movie Details'),
            _screenshot('/screenshots/player.webp', 'Video Player'),
          ]),
        ]),
      ]),

      // Features Grid
      Section(className: 'py-20 bg-white/[0.02]', children: [
        Div(className: 'max-w-6xl mx-auto px-4', children: [
          Div(className: 'text-center mb-12', children: [
            H2(className: 'text-3xl font-bold text-white mb-4',
                child: Text('Everything You Need')),
            P(className: 'text-gray-400',
                child: Text('A complete streaming solution out of the box.')),
          ]),
          Div(className: 'grid md:grid-cols-3 gap-6', children: [
            _featureCard('TV-Optimized UI',
                'Jetpack Compose for large screens with D-pad navigation.'),
            _featureCard('In-App Player',
                'ExoPlayer with HLS, DASH, and P2P adaptive streaming.'),
            _featureCard('60+ Subtitles',
                'SubDL integration with automatic subtitle fetching.'),
            _featureCard('Continue Watching',
                'Automatic progress tracking across sessions.'),
            _featureCard('Admin Panel',
                'Full content management with API docs built in.'),
            _featureCard('Distributed Delivery',
                'Peer-to-peer distribution for efficient content delivery at scale.'),
            _featureCard('Search & Browse',
                'Genre, rating, and infinite scroll browsing.'),
            _featureCard('Series Support',
                'Full season/episode management with progress.'),
          ]),
        ]),
      ]),

      // How It Works
      Section(className: 'py-20', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          Div(className: 'text-center mb-12', children: [
            H2(className: 'text-3xl font-bold text-white mb-4',
                child: Text('Up and Running in Minutes')),
          ]),
          Div(className: 'grid md:grid-cols-3 gap-8', children: [
            _step('1', 'Get License',
                'Purchase and receive your OMNI-XXXX-XXXX-XXXX-XXXX key.'),
            _step('2', 'Deploy Server',
                'Run a single Docker command with your license key.'),
            _step('3', 'Go Live',
                'Configure the app to your server URL and start streaming.'),
          ]),
        ]),
      ]),

      // Admin Panel Screenshots
      Section(className: 'py-20 bg-white/[0.02]', children: [
        Div(className: 'max-w-6xl mx-auto px-4', children: [
          Div(className: 'text-center mb-12', children: [
            H2(className: 'text-3xl font-bold text-white mb-4',
                child: Text('Powerful Admin Panel')),
            P(className: 'text-gray-400 max-w-xl mx-auto',
                child: Text(
                    'Manage your movie catalog, series, and curated collections with a modern web interface.')),
          ]),
          Div(className: 'grid md:grid-cols-2 gap-6', children: [
            _screenshot(
                '/screenshots/admin-home-sections.webp', 'Home Sections'),
            _screenshot('/screenshots/admin-movies.webp', 'Movies Management'),
            _screenshot('/screenshots/admin-tvshows.webp', 'TV Shows'),
          ]),
        ]),
      ]),

      // Lightbox Modal
      Div(
        id: 'lightbox',
        className: 'fixed inset-0 z-[100] hidden items-center justify-center bg-black/90 backdrop-blur-sm cursor-pointer',
        attributes: {'onclick': 'this.classList.add("hidden");this.classList.remove("flex")'},
        children: [
          Img(id: 'lightbox-img', src: '', alt: '', className: 'max-w-[90vw] max-h-[90vh] rounded-xl shadow-2xl'),
        ],
      ),
      script(content: '''
function openLightbox(src) {
  var lb = document.getElementById('lightbox');
  var img = document.getElementById('lightbox-img');
  img.src = src;
  lb.classList.remove('hidden');
  lb.classList.add('flex');
}
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') {
    var lb = document.getElementById('lightbox');
    lb.classList.add('hidden');
    lb.classList.remove('flex');
  }
});
      '''),

      // CTA Section
      Section(className: 'py-24', children: [
        Div(className: 'max-w-3xl mx-auto px-4 text-center', children: [
          H2(className: 'text-4xl font-bold text-white mb-6',
              child: Text('Ready to Launch Your Platform?')),
          P(className: 'text-xl text-gray-400 mb-10',
              child: Text(
                  'One-time purchase. Full source access. Deploy in minutes.')),
          Link(
            to: '/pricing',
            child: Span(
                className:
                    'inline-block px-10 py-4 bg-primary-500 text-white font-bold rounded-lg hover:bg-primary-600 transition-colors text-lg',
                child: Text('View Pricing \u2192')),
          ),
        ]),
      ]),
    ]);
  }

  Component _statItem(String value, String label) {
    return Div(className: 'text-center', children: [
      Div(className: 'text-3xl font-extrabold text-primary-500 mb-1',
          child: Text(value)),
      Div(className: 'text-sm text-gray-400',
          child: Text(label)),
    ]);
  }

  Component _screenshot(String src, String caption) {
    return Div(className: 'group cursor-pointer', attributes: {'onclick': 'openLightbox("$src")'}, children: [
      Div(
          className:
              'rounded-xl overflow-hidden border border-white/10 bg-white/5 group-hover:border-primary-500/30 transition-all',
          children: [
            Img(src: src, alt: caption, className: 'w-full h-auto group-hover:scale-[1.02] transition-transform'),
          ]),
      P(className: 'text-sm text-gray-500 text-center mt-3',
          child: Text(caption)),
    ]);
  }

  Component _featureCard(String title, String description) {
    return Div(
        className:
            'p-6 rounded-xl bg-white/5 border border-white/10 hover:border-primary-500/30 transition-colors',
        children: [
          H3(className: 'text-lg font-semibold text-white mb-2',
              child: Text(title)),
          P(className: 'text-sm text-gray-400',
              child: Text(description)),
        ]);
  }

  Component _step(String number, String title, String description) {
    return Div(className: 'text-center', children: [
      Div(
          className:
              'inline-flex items-center justify-center w-12 h-12 rounded-full bg-primary-500/10 text-primary-500 font-bold text-xl mb-4',
          child: Text(number)),
      H3(className: 'text-lg font-semibold text-white mb-2',
          child: Text(title)),
      P(className: 'text-sm text-gray-400',
          child: Text(description)),
    ]);
  }
}
