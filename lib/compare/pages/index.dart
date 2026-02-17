import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class ComparePage extends StatelessComponent {
  const ComparePage({super.key});

  // Platform names for table headers
  static const _platforms = ['Omnius', 'MoreScreens', 'Setplex', 'Jellyfin', 'Emby', 'Owncast'];

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-4xl mx-auto', children: [
          H1(
              className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Platform Comparison')),
          P(
              className: 'text-xl text-gray-400',
              child: Text(
                  'How Omnius compares to enterprise middleware and open-source media servers.')),
        ]),
      ]),

      // Platform Overview Cards
      Section(className: 'py-12', children: [
        Div(className: 'max-w-6xl mx-auto px-4', children: [
          Div(className: 'grid md:grid-cols-3 gap-4', children: [
            _platformCard('Omnius', 'Self-Hosted Streaming', 'Free',
                'Lightweight self-hosted streaming platform with admin panel, client apps, and full API. Deploy with Docker in minutes.',
                true),
            _platformCard('MoreScreens', 'Enterprise Middleware', 'Contact Sales',
                'Multi-screen video service delivery for telecom operators and broadcasters. Spectar+ platform with custom STB hardware.',
                false),
            _platformCard('Setplex', 'Enterprise OTT', 'Contact Sales',
                'End-to-end video delivery with Zapflex platform: middleware, transcoding, CDN, and NoraGo client apps.',
                false),
            _platformCard('Jellyfin', 'Open Source Media Server', 'Free',
                'Volunteer-built media server for personal libraries. Movies, shows, music, live TV, and DVR. Fully open source.',
                false),
            _platformCard('Emby', 'Personal Media Server', 'Freemium',
                'Personal media server with automatic transcoding, live TV, DVR, and parental controls. Premiere subscription for extras.',
                false),
            _platformCard('Owncast', 'Open Source Live Streaming', 'Free',
                'Self-hosted live video and chat server. Works with OBS and other broadcasting software. Fediverse integration.',
                false),
          ]),
        ]),
      ]),

      // Comparison Table
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-7xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Feature-by-Feature Comparison')),
          Div(
              className: 'rounded-xl bg-[#0d0d0d] border border-white/10 overflow-x-auto',
              children: [
                Table(className: 'w-full text-sm min-w-[900px]', children: [
                  // Header
                  Thead(
                      child: Tr(className: 'border-b border-white/10 bg-white/5', children: [
                        Th(className: 'text-left px-4 py-3 text-gray-400 font-medium min-w-[160px]',
                            child: Text('Feature')),
                        for (final p in _platforms)
                          Th(className: 'text-center px-3 py-3 font-semibold min-w-[100px] ${p == "Omnius" ? "text-primary-500" : "text-gray-400"}',
                              child: Text(p)),
                      ])),
                  Tbody(children: [
                    // --- Pricing ---
                    _sectionHeader('Pricing & Model'),
                    _row('Starting Price', ['Free', 'Custom', 'Custom', 'Free', 'Free', 'Free']),
                    _row('Pricing Model', ['Free / Self-hosted', 'Annual + services', 'Annual + services', 'Open source', 'Freemium', 'Open source']),
                    _row('Commercial Use', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),
                    _row('No Vendor Lock-in', ['\u2713', '\u2717', '\u2717', '\u2713', '\u2717', '\u2713']),

                    // --- Deployment ---
                    _sectionHeader('Deployment'),
                    _row('Docker Deploy', ['\u2713', '\u2717', '\u2717', '\u2713', '\u2713', '\u2713']),
                    _row('Setup Time', ['Minutes', 'Weeks', 'Weeks', 'Minutes', 'Minutes', 'Minutes']),
                    _row('Self-Hosted', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),
                    _row('Managed Cloud', ['\u2717', '\u2713', '\u2713', '\u2717', '\u2713', '\u2717']),
                    _row('Embedded Database', ['\u2713', '\u2717', '\u2717', '\u2713', '\u2713', '\u2713']),
                    _row('Zero External Dependencies', ['\u2713', '\u2717', '\u2717', '\u2713', '\u2713', '\u2713']),

                    // --- Streaming ---
                    _sectionHeader('Streaming Protocols'),
                    _row('HLS', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),
                    _row('MPEG-DASH', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Progressive HTTP', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('P2P Distribution', ['\u2713', '\u2717', '\u2717', '\u2717', '\u2717', '\u2717']),
                    _row('Playlist Import', ['\u2717', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Multicast', ['\u2717', '\u2713', '\u2713', '\u2717', '\u2717', '\u2717']),
                    _row('RTMP Ingest', ['\u2717', '\u2717', '\u2713', '\u2717', '\u2717', '\u2713']),

                    // --- Content ---
                    _sectionHeader('Content Management'),
                    _row('Movie Catalog', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Series & Episodes', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Live Streams', ['\u2717', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),
                    _row('EPG / Program Guide', ['\u2717', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Music Library', ['\u2717', '\u2717', '\u2717', '\u2713', '\u2713', '\u2717']),
                    _row('DVR / Recording', ['\u2717', '\u2717', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Admin Panel', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),
                    _row('REST API', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),

                    // --- Client Apps ---
                    _sectionHeader('Client Applications'),
                    _row('Android TV', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('macOS', ['\u2713', '\u2717', '\u2717', '\u2713', '\u2713', '\u2717']),
                    _row('iOS', ['Roadmap', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Web Player', ['Roadmap', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),
                    _row('Samsung Tizen', ['In Review', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('LG WebOS', ['In Review', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Roku', ['\u2717', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Custom STB Hardware', ['\u2717', '\u2713', '\u2713', '\u2717', '\u2717', '\u2717']),

                    // --- Advanced ---
                    _sectionHeader('Advanced Features'),
                    _row('Transcoding', ['\u2717', '\u2713', '\u2713', '\u2713', '\u2713', '\u2713']),
                    _row('DRM (Widevine/FairPlay)', ['Roadmap', '\u2713', '\u2713', '\u2717', '\u2717', '\u2717']),
                    _row('CDN Management', ['\u2717', '\u2713', '\u2713', '\u2717', '\u2717', '\u2717']),
                    _row('Multi-Tenancy', ['\u2717', '\u2713', '\u2713', '\u2717', '\u2717', '\u2717']),
                    _row('Subtitles (60+ languages)', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Continue Watching', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('User Accounts', ['\u2713', '\u2713', '\u2713', '\u2713', '\u2713', '\u2717']),
                    _row('Monetization (SVOD/AVOD)', ['\u2717', '\u2713', '\u2713', '\u2717', '\u2717', '\u2717']),
                    _row('Fediverse Integration', ['\u2717', '\u2717', '\u2717', '\u2717', '\u2717', '\u2713']),
                  ]),
                ]),
              ]),
        ]),
      ]),

      // Positioning
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Where Omnius Fits')),
          Div(className: 'space-y-6', children: [
            Div(
                className: 'rounded-xl bg-white/5 border border-white/10 p-6',
                children: [
                  H3(className: 'text-lg font-semibold text-white mb-2',
                      child: Text('Enterprise Platforms (MoreScreens, Setplex)')),
                  P(className: 'text-sm text-gray-400 leading-relaxed',
                      child: Text(
                          'Built for telecom operators and large broadcasters. They offer end-to-end managed infrastructure with custom hardware, multi-DRM, transcoding appliances, and professional services. Require dedicated teams and enterprise budgets.')),
                ]),
            Div(
                className: 'rounded-xl bg-primary-500/5 border border-primary-500/20 p-6',
                children: [
                  H3(className: 'text-lg font-semibold text-primary-500 mb-2',
                      child: Text('Omnius')),
                  P(className: 'text-sm text-gray-300 leading-relaxed',
                      child: Text(
                          'Professional streaming platform in a single Docker container. Purpose-built for streaming with dedicated client apps (Android TV, macOS), content management, and a full content API. Free, self-hosted, no vendor lock-in.')),
                ]),
            Div(
                className: 'rounded-xl bg-white/5 border border-white/10 p-6',
                children: [
                  H3(className: 'text-lg font-semibold text-white mb-2',
                      child: Text('Media Servers (Jellyfin, Emby)')),
                  P(className: 'text-sm text-gray-400 leading-relaxed',
                      child: Text(
                          'Personal media servers designed for organizing your own media library at home. Great for local playback and transcoding, but not purpose-built for running a streaming service with user management and content delivery at scale.')),
                ]),
            Div(
                className: 'rounded-xl bg-white/5 border border-white/10 p-6',
                children: [
                  H3(className: 'text-lg font-semibold text-white mb-2',
                      child: Text('Live-Only (Owncast)')),
                  P(className: 'text-sm text-gray-400 leading-relaxed',
                      child: Text(
                          'Focused exclusively on live streaming with chat. No VOD catalog, no series management, no EPG. Ideal for individual streamers, but not a full streaming platform.')),
                ]),
          ]),
        ]),
      ]),

      // CTA
      Section(className: 'py-20 text-center', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(
              className: 'text-3xl font-bold text-white mb-4',
              child: Text('Ready to Get Started?')),
          P(
              className: 'text-gray-400 mb-8',
              child: Text(
                  'Professional streaming technology. Free and self-hosted. Deploy in minutes.')),
          Div(className: 'flex justify-center gap-4 flex-wrap', children: [
            Link(
              to: '/pricing',
              child: Span(
                  className: 'px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                  child: Text('Get Started \u2192')),
            ),
            Link(
              to: '/technology',
              child: Span(
                  className: 'px-8 py-3.5 border border-white/20 text-white font-semibold rounded-lg hover:bg-white/5 transition-colors',
                  child: Text('Explore Technology')),
            ),
          ]),
        ]),
      ]),
    ]);
  }

  Component _platformCard(String name, String category, String price, String desc, bool highlight) {
    return Div(
        className: highlight
            ? 'p-5 rounded-xl bg-primary-500/5 border border-primary-500/20'
            : 'p-5 rounded-xl bg-white/5 border border-white/10',
        children: [
          Div(className: 'flex items-center justify-between mb-2', children: [
            H3(className: 'text-lg font-bold text-white', child: Text(name)),
            Span(
                className: 'text-xs px-2 py-0.5 rounded-full font-medium ${highlight ? "bg-primary-500/20 text-primary-500" : "bg-white/10 text-gray-400"}',
                child: Text(price)),
          ]),
          P(className: 'text-xs text-gray-500 mb-2', child: Text(category)),
          P(className: 'text-sm text-gray-400 leading-relaxed', child: Text(desc)),
        ]);
  }

  Component _sectionHeader(String title) {
    return Tr(className: 'bg-white/[0.03]', children: [
      Td(
          className: 'px-4 py-3 text-white font-semibold text-sm',
          attributes: {'colspan': '7'},
          child: Text(title)),
    ]);
  }

  Component _row(String feature, List<String> values) {
    return Tr(className: 'border-b border-white/5', children: [
      Td(className: 'px-4 py-2.5 text-gray-300 text-sm', child: Text(feature)),
      for (var i = 0; i < values.length; i++)
        Td(
            className: 'px-3 py-2.5 text-center text-sm',
            child: Span(
                className: values[i] == '\u2713'
                    ? (i == 0 ? 'text-green-400 font-bold' : 'text-green-500')
                    : values[i] == '\u2717'
                        ? 'text-red-500/60'
                        : (i == 0 ? 'text-gray-200' : 'text-gray-500'),
                child: Text(values[i]))),
    ]);
  }
}
