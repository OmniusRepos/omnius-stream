import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class ComparePage extends StatelessComponent {
  const ComparePage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-3xl mx-auto', children: [
          H1(
              className:
                  'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Omnius vs. MoreScreens')),
          P(
              className: 'text-xl text-gray-400',
              child: Text(
                  'Enterprise streaming technology without the enterprise price tag. See how Omnius compares to traditional middleware platforms.')),
        ]),
      ]),

      // At a Glance
      Section(className: 'py-12', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          Div(className: 'grid md:grid-cols-2 gap-8', children: [
            // Omnius
            Div(
                className:
                    'rounded-xl bg-primary-500/5 border border-primary-500/20 p-6',
                children: [
                  Div(className: 'flex items-center gap-3 mb-4', children: [
                    Span(
                        className: 'text-2xl font-bold text-white',
                        child: Text('Omnius')),
                    Span(
                        className:
                            'text-xs px-2 py-0.5 rounded-full bg-primary-500/20 text-primary-500 font-medium',
                        child: Text('Self-Hosted')),
                  ]),
                  P(
                      className: 'text-gray-400 text-sm mb-4',
                      child: Text(
                          'A lightweight, self-hosted streaming platform for independent operators, content creators, and small businesses. Deploy in minutes with Docker.')),
                  Div(className: 'space-y-2', children: [
                    _glanceItem('One-time license from \$99'),
                    _glanceItem('Single Docker container deployment'),
                    _glanceItem('Built-in admin panel & client apps'),
                    _glanceItem('No external dependencies'),
                    _glanceItem('Full control of your infrastructure'),
                  ]),
                ]),
            // MoreScreens
            Div(
                className:
                    'rounded-xl bg-white/5 border border-white/10 p-6',
                children: [
                  Div(className: 'flex items-center gap-3 mb-4', children: [
                    Span(
                        className: 'text-2xl font-bold text-white',
                        child: Text('MoreScreens')),
                    Span(
                        className:
                            'text-xs px-2 py-0.5 rounded-full bg-white/10 text-gray-400 font-medium',
                        child: Text('Enterprise')),
                  ]),
                  P(
                      className: 'text-gray-400 text-sm mb-4',
                      child: Text(
                          'An enterprise multi-screen video service delivery platform for telecom operators, broadcasters, and hospitality. Requires custom sales engagement.')),
                  Div(className: 'space-y-2', children: [
                    _glanceItem('Custom enterprise pricing (contact sales)'),
                    _glanceItem('On-premises or managed cloud deployment'),
                    _glanceItem('Middleware + hardware + professional services'),
                    _glanceItem('Requires dedicated infrastructure team'),
                    _glanceItem('Vendor-managed platform'),
                  ]),
                ]),
          ]),
        ]),
      ]),

      // Comparison Table
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Feature Comparison')),
          Div(
              className:
                  'rounded-xl bg-[#0d0d0d] border border-white/10 overflow-hidden overflow-x-auto',
              children: [
                Table(className: 'w-full text-sm', children: [
                  Thead(
                      child: Tr(
                          className:
                              'border-b border-white/10 bg-white/5',
                          children: [
                        Th(
                            className:
                                'text-left px-6 py-4 text-gray-400 font-medium',
                            child: Text('Feature')),
                        Th(
                            className:
                                'text-center px-6 py-4 text-primary-500 font-semibold',
                            child: Text('Omnius')),
                        Th(
                            className:
                                'text-center px-6 py-4 text-gray-400 font-medium',
                            child: Text('MoreScreens')),
                      ])),
                  Tbody(children: [
                    _headerRow('Pricing & Licensing'),
                    _compareRow('Starting Price', '\$99 one-time', 'Custom (contact sales)'),
                    _compareRow('Pricing Model', 'One-time purchase', 'Annual license + services'),
                    _compareRow('Free Trial', 'Admin panel (no license needed)', 'Demo on request'),

                    _headerRow('Deployment'),
                    _compareRow('Setup Time', 'Minutes (Docker)', 'Weeks to months'),
                    _compareRow('Infrastructure', 'Single Docker container', 'Dedicated servers / managed cloud'),
                    _compareRow('Database', 'Embedded SQLite (zero-config)', 'External database required'),
                    _compareRow('Maintenance', 'Self-managed, pull latest image', 'Vendor-managed or dedicated team'),
                    _compareRow('On-Premises', '\u2713', '\u2713'),
                    _compareRow('Cloud Deployment', '\u2713 (any Docker host)', '\u2713 (managed service)'),

                    _headerRow('Streaming Protocols'),
                    _compareRow('HLS', '\u2713', '\u2713'),
                    _compareRow('MPEG-DASH', '\u2713', '\u2713'),
                    _compareRow('Progressive HTTP', '\u2713', '\u2713'),
                    _compareRow('P2P Distribution', '\u2713', '\u2717'),
                    _compareRow('IPTV / M3U Import', '\u2713', '\u2713'),
                    _compareRow('Multicast', '\u2717', '\u2713'),

                    _headerRow('Content Management'),
                    _compareRow('Movie Catalog', '\u2713', '\u2713'),
                    _compareRow('Series & Episodes', '\u2713', '\u2713'),
                    _compareRow('Live Streams', '\u2713', '\u2713'),
                    _compareRow('EPG / Program Guide', '\u2713', '\u2713'),
                    _compareRow('Admin Panel', '\u2713 (built-in web UI)', '\u2713 (Spectar+ CMS)'),
                    _compareRow('Catch-Up TV', 'Roadmap', '\u2713'),
                    _compareRow('Radio / Audio', 'Roadmap', '\u2713'),

                    _headerRow('Client Applications'),
                    _compareRow('Android TV', '\u2713 (Jetpack Compose)', '\u2713 (custom STB)'),
                    _compareRow('macOS', '\u2713 (SwiftUI)', '\u2717'),
                    _compareRow('iOS / iPhone', 'Roadmap', '\u2713'),
                    _compareRow('Samsung Tizen', 'Roadmap', '\u2713'),
                    _compareRow('LG WebOS', 'Roadmap', '\u2713'),
                    _compareRow('Roku', '\u2717', '\u2713'),
                    _compareRow('Web Player', 'Roadmap', '\u2713'),
                    _compareRow('Custom STB Hardware', '\u2717', '\u2713 (ERO box)'),

                    _headerRow('Security & DRM'),
                    _compareRow('License Validation', '\u2713 (heartbeat)', '\u2713'),
                    _compareRow('Widevine DRM', 'Roadmap', '\u2713'),
                    _compareRow('FairPlay DRM', 'Roadmap', '\u2713'),
                    _compareRow('PlayReady DRM', '\u2717', '\u2713'),

                    _headerRow('Advanced Features'),
                    _compareRow('REST API', '\u2713', '\u2713'),
                    _compareRow('Multi-Tenancy', '\u2717', '\u2713'),
                    _compareRow('Analytics & Reporting', 'Basic', 'Advanced'),
                    _compareRow('CDN Management', '\u2717 (BYO CDN)', '\u2713 (built-in)'),
                    _compareRow('Transcoding', '\u2717 (BYO)', '\u2713 (MT-LIVE appliance)'),
                    _compareRow('Subtitles (60+ languages)', '\u2713', '\u2713'),
                  ]),
                ]),
              ]),
        ]),
      ]),

      // Who is it for
      Section(className: 'py-12', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Which Platform Is Right for You?')),
          Div(className: 'grid md:grid-cols-2 gap-8', children: [
            Div(
                className:
                    'rounded-xl bg-primary-500/5 border border-primary-500/20 p-6',
                children: [
                  H3(
                      className:
                          'text-xl font-bold text-white mb-4',
                      child: Text('Choose Omnius if you\u2026')),
                  Div(className: 'space-y-3', children: [
                    _choiceItem('Want to launch a streaming service without a large upfront investment'),
                    _choiceItem('Need full control over your infrastructure and data'),
                    _choiceItem('Prefer self-hosted with Docker deployment'),
                    _choiceItem('Are an independent operator, content creator, or small business'),
                    _choiceItem('Want Android TV and macOS client apps included'),
                    _choiceItem('Value simplicity over complex enterprise features'),
                  ]),
                ]),
            Div(
                className:
                    'rounded-xl bg-white/5 border border-white/10 p-6',
                children: [
                  H3(
                      className:
                          'text-xl font-bold text-white mb-4',
                      child: Text('Choose MoreScreens if you\u2026')),
                  Div(className: 'space-y-3', children: [
                    _choiceItem('Are a telecom operator or large broadcaster'),
                    _choiceItem('Need multi-DRM with Widevine, FairPlay, and PlayReady'),
                    _choiceItem('Require dedicated hardware (set-top boxes, transcoding appliances)'),
                    _choiceItem('Need multi-tenancy for managing multiple service brands'),
                    _choiceItem('Want vendor-managed infrastructure and professional services'),
                    _choiceItem('Have a dedicated team for platform operations'),
                  ]),
                ]),
          ]),
        ]),
      ]),

      // Bottom line
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-3xl mx-auto px-4 text-center', children: [
          H2(
              className: 'text-2xl font-bold text-white mb-6',
              child: Text('The Bottom Line')),
          P(
              className: 'text-gray-400 leading-relaxed mb-4',
              child: Text(
                  'MoreScreens (Spectar+) is built for telecom companies and large broadcasters who need end-to-end managed infrastructure with custom hardware, multi-DRM, and professional services contracts.')),
          P(
              className: 'text-gray-300 leading-relaxed',
              child: Text(
                  'Omnius is built for everyone else \u2014 independent operators, content creators, and businesses who want professional streaming technology in a simple, self-hosted package at a fraction of the cost.')),
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
                  'Deploy your own streaming platform in minutes. No sales calls, no contracts, no waiting.')),
          Div(className: 'flex justify-center gap-4 flex-wrap', children: [
            Link(
              to: '/pricing',
              child: Span(
                  className:
                      'px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                  child: Text('View Pricing \u2192')),
            ),
            Link(
              to: '/technology',
              child: Span(
                  className:
                      'px-8 py-3.5 border border-white/20 text-white font-semibold rounded-lg hover:bg-white/5 transition-colors',
                  child: Text('Explore Technology')),
            ),
          ]),
        ]),
      ]),
    ]);
  }

  Component _glanceItem(String text) {
    return Div(className: 'flex items-start gap-2', children: [
      Span(
          className: 'text-gray-500 mt-0.5 text-sm',
          child: Text('\u2022')),
      Span(
          className: 'text-sm text-gray-300',
          child: Text(text)),
    ]);
  }

  Component _headerRow(String title) {
    return Tr(
        className: 'bg-white/[0.03]',
        children: [
          Td(
              className:
                  'px-6 py-3 text-white font-semibold text-sm',
              attributes: {'colspan': '3'},
              child: Text(title)),
        ]);
  }

  Component _compareRow(String feature, String omnius, String moreScreens) {
    return Tr(className: 'border-b border-white/5', children: [
      Td(
          className: 'px-6 py-3 text-gray-300 text-sm',
          child: Text(feature)),
      Td(
          className: 'px-6 py-3 text-center text-sm',
          child: Span(
              className: omnius == '\u2713'
                  ? 'text-green-500'
                  : omnius == '\u2717'
                      ? 'text-red-500'
                      : 'text-gray-300',
              child: Text(omnius))),
      Td(
          className: 'px-6 py-3 text-center text-sm',
          child: Span(
              className: moreScreens == '\u2713'
                  ? 'text-green-500'
                  : moreScreens == '\u2717'
                      ? 'text-red-500'
                      : 'text-gray-400',
              child: Text(moreScreens))),
    ]);
  }

  Component _choiceItem(String text) {
    return Div(className: 'flex items-start gap-2', children: [
      Span(
          className: 'text-primary-500 mt-0.5',
          child: Text('\u2713')),
      Span(
          className: 'text-sm text-gray-300',
          child: Text(text)),
    ]);
  }
}
