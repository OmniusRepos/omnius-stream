import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class TechnologyPage extends StatelessComponent {
  const TechnologyPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-3xl mx-auto', children: [
          H1(
              className:
                  'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Technology')),
          P(
              className: 'text-xl text-gray-400',
              child: Text(
                  'A modern streaming platform built on open standards. Omnius supports the protocols and formats that power professional video delivery.')),
        ]),
      ]),

      // Protocol Grid
      Section(className: 'py-12', children: [
        Div(className: 'max-w-6xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Supported Protocols & Standards')),
          Div(className: 'grid md:grid-cols-3 gap-6', children: [
            _protocolCard(
              'HLS',
              'HTTP Live Streaming',
              'Apple\u2019s adaptive bitrate protocol. Industry standard for delivering live and on-demand video across devices. Supported by virtually every player and CDN.',
              'Adaptive Bitrate',
            ),
            _protocolCard(
              'DASH',
              'Dynamic Adaptive Streaming over HTTP',
              'MPEG-DASH is the international standard for adaptive streaming. Codec-agnostic and widely supported by Android, smart TVs, and web browsers.',
              'Open Standard',
            ),
            _protocolCard(
              'REST API',
              'JSON Content API',
              'Full REST API for client apps and third-party integrations. Manage movies, series, and collections programmatically with comprehensive JSON endpoints.',
              'Developer Friendly',
            ),
            _protocolCard(
              'OTT',
              'Over-the-Top Delivery',
              'Deliver video content directly over the internet without requiring traditional cable or satellite infrastructure. Full OTT platform capabilities built in.',
              'Internet Delivery',
            ),
            _protocolCard(
              'P2P',
              'Peer-to-Peer Distribution',
              'Distributed content delivery reduces origin server bandwidth by leveraging peer networks. Efficient at scale with automatic peer discovery and fallback to direct streaming.',
              'Cost Efficient',
            ),
            _protocolCard(
              'Direct Stream',
              'HTTP Progressive & Direct URL',
              'Support for direct video URLs with progressive download. Serve content from any HTTP source including cloud storage, CDN origins, or local file servers.',
              'Universal',
            ),
          ]),
        ]),
      ]),

      // Architecture
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Platform Architecture')),
          Div(className: 'grid md:grid-cols-2 gap-8', children: [
            // Server
            Div(
                className:
                    'rounded-xl bg-white/5 border border-white/10 p-6',
                children: [
                  H3(
                      className: 'text-lg font-semibold text-white mb-4',
                      child: Text('Server')),
                  Div(className: 'space-y-3', children: [
                    _archItem('Go (Golang)',
                        'High-performance server with low memory footprint'),
                    _archItem('SQLite',
                        'Zero-config embedded database, no external services needed'),
                    _archItem('Chi Router',
                        'Lightweight HTTP routing with middleware support'),
                    _archItem('REST API',
                        'Full JSON API for client apps and third-party integrations'),
                    _archItem('Admin Panel',
                        'Built-in Svelte web interface for content management'),
                  ]),
                ]),
            // Client
            Div(
                className:
                    'rounded-xl bg-white/5 border border-white/10 p-6',
                children: [
                  H3(
                      className: 'text-lg font-semibold text-white mb-4',
                      child: Text('Client Apps')),
                  Div(className: 'space-y-3', children: [
                    _archItem('Android TV',
                        'Jetpack Compose with D-pad navigation and ExoPlayer'),
                    _archItem('macOS',
                        'Native SwiftUI app with AVPlayer integration'),
                    _archItem('ExoPlayer',
                        'HLS, DASH, and progressive streaming with adaptive bitrate'),
                    _archItem('Subtitles',
                        'SubDL integration with 60+ languages'),
                    _archItem('Multi-Server',
                        'Connect to any Omnius instance by URL'),
                  ]),
                ]),
          ]),
        ]),
      ]),

      // Content Management
      Section(className: 'py-12', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Content Management')),
          Div(className: 'grid md:grid-cols-3 gap-6', children: [
            _contentCard('Movies & Catalog',
                'Full movie catalog management with metadata, posters, ratings, genres, and search. Import from external sources or add content manually through the admin panel.'),
            _contentCard('Series & Episodes',
                'Organize TV shows by season and episode. Automatic next-episode queuing, series-level progress tracking, and batch content management.'),
            _contentCard('Curated Lists',
                'Create custom collections with filters and sorting. Organize content into themed lists for your viewers.'),
          ]),
        ]),
      ]),

      // Formats table
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Format & Codec Support')),
          Div(
              className:
                  'rounded-xl bg-[#0d0d0d] border border-white/10 overflow-hidden',
              children: [
                Table(className: 'w-full text-sm', children: [
                  Thead(
                      child: Tr(
                          className: 'border-b border-white/10',
                          children: [
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium',
                            child: Text('Category')),
                        Th(
                            className:
                                'text-left px-6 py-3 text-gray-400 font-medium',
                            child: Text('Supported Formats')),
                      ])),
                  Tbody(children: [
                    _formatRow('Video Containers', 'MP4, MKV, WebM, TS, FLV, AVI'),
                    _formatRow('Video Codecs', 'H.264 (AVC), H.265 (HEVC), VP9, AV1'),
                    _formatRow('Audio Codecs', 'AAC, AC3, EAC3, Opus, FLAC, MP3'),
                    _formatRow('Streaming Protocols', 'HLS, DASH, Progressive HTTP, RTSP'),
                    _formatRow('Subtitle Formats', 'SRT, VTT, SSA/ASS, TTML'),
                    _formatRow('Image Formats', 'JPEG, PNG, WebP (posters & thumbnails)'),
                  ]),
                ]),
              ]),
        ]),
      ]),

      // Deployment
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Deployment')),
          Div(className: 'grid md:grid-cols-3 gap-6', children: [
            _deployCard('\u{1f433}', 'Docker',
                'Single container deployment. Works on any Linux server, VPS, or cloud instance. One command to get started.'),
            _deployCard('\u{2601}\u{fe0f}', 'Cloud Ready',
                'Deploy on AWS, Google Cloud, DigitalOcean, Hetzner, or any provider that runs Docker. No vendor lock-in.'),
            _deployCard('\u{1f512}', 'Self-Hosted',
                'Your data stays on your infrastructure. No third-party dependencies, no external databases, no cloud services required.'),
          ]),
        ]),
      ]),

      // CTA
      Section(className: 'py-20 text-center', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(
              className: 'text-3xl font-bold text-white mb-4',
              child: Text('See How We Compare')),
          P(
              className: 'text-gray-400 mb-8',
              child: Text(
                  'Omnius delivers enterprise-grade streaming technology at a fraction of the cost.')),
          Div(className: 'flex justify-center gap-4', children: [
            Link(
              to: '/compare',
              child: Span(
                  className:
                      'px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                  child: Text('Compare Platforms \u2192')),
            ),
            Link(
              to: '/pricing',
              child: Span(
                  className:
                      'px-8 py-3.5 border border-white/20 text-white font-semibold rounded-lg hover:bg-white/5 transition-colors',
                  child: Text('Setup Guide')),
            ),
          ]),
        ]),
      ]),
    ]);
  }

  Component _protocolCard(
      String name, String fullName, String description, String badge) {
    return Div(
        className:
            'p-6 rounded-xl bg-white/5 border border-white/10 hover:border-primary-500/30 transition-all',
        children: [
          Div(className: 'flex items-center gap-3 mb-3', children: [
            H3(
                className: 'text-lg font-bold text-white',
                child: Text(name)),
            Span(
                className:
                    'text-xs px-2 py-0.5 rounded-full bg-primary-500/10 text-primary-500 font-medium',
                child: Text(badge)),
          ]),
          P(
              className: 'text-xs text-gray-500 mb-2',
              child: Text(fullName)),
          P(
              className: 'text-sm text-gray-400 leading-relaxed',
              child: Text(description)),
        ]);
  }

  Component _archItem(String label, String desc) {
    return Div(className: 'flex items-start gap-3', children: [
      Span(
          className:
              'flex-shrink-0 mt-1 w-1.5 h-1.5 rounded-full bg-primary-500',
          child: Text('')),
      Div(children: [
        Span(
            className: 'text-sm font-medium text-white',
            child: Text(label)),
        Span(
            className: 'text-sm text-gray-500',
            child: Text(' \u2014 $desc')),
      ]),
    ]);
  }

  Component _contentCard(String title, String desc) {
    return Div(
        className:
            'p-6 rounded-xl bg-white/5 border border-white/10',
        children: [
          H3(
              className: 'text-lg font-semibold text-white mb-3',
              child: Text(title)),
          P(
              className: 'text-sm text-gray-400 leading-relaxed',
              child: Text(desc)),
        ]);
  }

  Component _formatRow(String category, String formats) {
    return Tr(className: 'border-b border-white/5', children: [
      Td(
          className: 'px-6 py-3 text-white font-medium text-sm',
          child: Text(category)),
      Td(
          className: 'px-6 py-3 text-gray-400 text-sm font-mono',
          child: Text(formats)),
    ]);
  }

  Component _deployCard(String icon, String title, String desc) {
    return Div(
        className:
            'p-6 rounded-xl bg-white/5 border border-white/10 text-center',
        children: [
          Div(className: 'text-3xl mb-3', child: Text(icon)),
          H3(
              className: 'text-lg font-semibold text-white mb-2',
              child: Text(title)),
          P(
              className: 'text-sm text-gray-400 leading-relaxed',
              child: Text(desc)),
        ]);
  }
}
