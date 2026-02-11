import 'package:duxt_html/duxt_html.dart';
import 'package:duxt_ui/duxt_ui.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class ServerPage extends StatelessComponent {
  const ServerPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-4xl mx-auto', children: [
          H1(
              className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Omnius Server')),
          P(
              className: 'text-xl text-gray-400',
              child: Text(
                  'Self-hosted streaming platform. Download, configure, and run. Full control over your infrastructure.')),
        ]),
      ]),

      // What You Get
      Section(className: 'py-12', children: [
        Div(className: 'max-w-5xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-8 text-center',
              child: Text('Everything in One Binary')),
          Div(className: 'grid md:grid-cols-2 lg:grid-cols-3 gap-6', children: [
            _featureCard('Admin Panel', 'Manage movies, series, curated lists, and user accounts from a web interface.'),
            _featureCard('REST API', 'Full JSON API for client apps. HLS, DASH, and progressive HTTP streaming.'),
            _featureCard('Embedded Database', 'SQLite — no external database required. Zero dependencies.'),
            _featureCard('Curated Lists', 'Create custom collections with filters and sorting. Organize content for your viewers.'),
            _featureCard('Multi-User', 'Create accounts for your users with individual access and continue-watching support.'),
            _featureCard('P2P Distribution', 'Built-in peer-to-peer content distribution to reduce server bandwidth.'),
          ]),
        ]),
      ]),

      // Server Costs
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-4 text-center',
              child: Text('Server Costs')),
          P(className: 'text-gray-400 mb-8 text-center',
              child: Text('Omnius is lightweight. A basic VPS is all you need.')),
          Div(className: 'grid md:grid-cols-3 gap-6', children: [
            _costCard('Starter', '\$4-6/mo', [
              '1 vCPU, 1 GB RAM',
              'Up to 10 concurrent viewers',
              'DigitalOcean, Hetzner, Vultr',
            ]),
            _costCard('Standard', '\$6-12/mo', [
              '2 vCPU, 2 GB RAM',
              'Up to 50 concurrent viewers',
              'Any cloud provider',
            ]),
            _costCard('Home Server', 'Free', [
              'Raspberry Pi 4/5, NAS, old PC',
              'Runs on Linux, macOS, Windows',
              'No monthly costs',
            ]),
          ]),
          P(className: 'text-sm text-gray-500 text-center mt-6',
              child: Text('Omnius does not transcode — it proxies streams directly. CPU usage is minimal.')),
        ]),
      ]),

      // Quick Start
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6 text-center',
              child: Text('Quick Start')),
          P(className: 'text-gray-400 mb-6 text-center',
              child: Text('Choose your preferred method:')),
          DTabs(
            defaultValue: 'binary',
            items: [
              DTabItem(
                value: 'binary',
                label: 'Binary',
                content: Div(children: [
                  _codeBlock(
                      '# Download from GitHub Releases\n'
                      'wget https://github.com/OmniusRepos/omnius-releases/releases/download/server-1.0.0/omnius-linux-amd64\n'
                      'chmod +x omnius-linux-amd64\n'
                      '\n'
                      '# Run with your license key\n'
                      'LICENSE_KEY=YOUR_LICENSE_KEY \\\n'
                      'ADMIN_PASSWORD=your_secure_password \\\n'
                      './omnius-linux-amd64'),
                ]),
              ),
              DTabItem(
                value: 'docker',
                label: 'Docker',
                content: Div(children: [
                  _codeBlock(
                      'docker run -d \\\n'
                      '  --name omnius \\\n'
                      '  -p 8080:8080 \\\n'
                      '  -e LICENSE_KEY=YOUR_LICENSE_KEY \\\n'
                      '  -e ADMIN_PASSWORD=your_secure_password \\\n'
                      '  -v omnius-data:/app/data \\\n'
                      '  ghcr.io/omniusrepos/omnius-releases:latest'),
                ]),
              ),
              DTabItem(
                value: 'podman',
                label: 'Podman',
                content: Div(children: [
                  _codeBlock(
                      'podman run -d \\\n'
                      '  --name omnius \\\n'
                      '  -p 8080:8080 \\\n'
                      '  -e LICENSE_KEY=YOUR_LICENSE_KEY \\\n'
                      '  -e ADMIN_PASSWORD=your_secure_password \\\n'
                      '  -v omnius-data:/app/data \\\n'
                      '  ghcr.io/omniusrepos/omnius-releases:latest'),
                ]),
              ),
            ],
          ),
          Div(className: 'text-center mt-6', children: [
            Link(
              to: '/app/setup',
              child: Span(
                  className: 'text-primary-500 hover:text-primary-400 font-medium transition-colors',
                  child: Text('Full setup guide with all platforms, env vars, and more \u2192')),
            ),
          ]),
        ]),
      ]),

      // Get Your License
      Section(className: 'py-16 text-center', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(
              className: 'text-3xl font-bold text-white mb-4',
              child: Text('Get Your License')),
          P(
              className: 'text-gray-400 mb-8',
              child: Text(
                  'One-time purchase. No subscriptions. Includes all future updates and free client apps.')),
          Link(
            to: '/pricing',
            child: Span(
                className: 'px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                child: Text('View Pricing \u2192')),
          ),
        ]),
      ]),

      // Looking for Apps?
      Section(className: 'py-20 text-center bg-[#141414]', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(
              className: 'text-3xl font-bold text-white mb-4',
              child: Text('Looking for Apps?')),
          P(
              className: 'text-gray-400 mb-8',
              child: Text(
                  'Free native apps for Android TV, macOS, LG webOS, Samsung Tizen, and more.')),
          Link(
            to: '/apps',
            child: Span(
                className: 'px-8 py-3.5 border border-white/20 text-white font-semibold rounded-lg hover:bg-white/5 transition-colors',
                child: Text('Browse Apps \u2192')),
          ),
        ]),
      ]),
    ]);
  }

  Component _codeBlock(String code) {
    return Div(
        className:
            'rounded-xl bg-[#0d0d0d] border border-white/10 p-6 overflow-x-auto',
        children: [
          Pre(child:
            Code(className: 'text-sm text-gray-300 whitespace-pre',
                child: Text(code))),
        ]);
  }

  Component _featureCard(String title, String desc) {
    return Div(
        className: 'p-5 rounded-xl bg-white/5 border border-white/10',
        children: [
          H3(className: 'text-lg font-bold text-white mb-2', child: Text(title)),
          P(className: 'text-sm text-gray-400 leading-relaxed', child: Text(desc)),
        ]);
  }

  Component _costCard(String tier, String price, List<String> details) {
    return Div(
        className: 'p-6 rounded-xl bg-white/5 border border-white/10',
        children: [
          H3(className: 'text-lg font-bold text-white mb-1', child: Text(tier)),
          P(className: 'text-2xl font-extrabold text-primary-500 mb-4', child: Text(price)),
          Div(className: 'space-y-2', children: [
            for (final detail in details)
              P(className: 'text-sm text-gray-400', child: Text(detail)),
          ]),
        ]);
  }
}
