import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr_router/jaspr_router.dart';

class SetupPage extends StatelessComponent {
  const SetupPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-3xl mx-auto', children: [
          H1(className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Setup & Deployment')),
          P(className: 'text-xl text-gray-400',
              child: Text(
                  'Get your Omnius streaming server running in minutes with Docker.')),
        ]),
      ]),

      // Quick Start with Docker
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('1. Quick Start with Docker')),
          P(className: 'text-gray-400 mb-4',
              child: Text('The fastest way to get started. Run this single command:')),
          Div(
              className:
                  'rounded-xl bg-[#0d0d0d] border border-white/10 p-6 overflow-x-auto',
              children: [
                Pre(child:
                  Code(className: 'text-sm text-gray-300 whitespace-pre',
                      child: Text(
                          'docker run -d \\\n'
                          '  --name omnius \\\n'
                          '  -p 8080:8080 \\\n'
                          '  -e LICENSE_KEY=YOUR_LICENSE_KEY \\\n'
                          '  -e ADMIN_PASSWORD=your_secure_password \\\n'
                          '  -v omnius-data:/app/data \\\n'
                          '  ghcr.io/omnius-stream/server:latest'))),
              ]),
        ]),
      ]),

      // Docker Compose
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('2. Docker Compose (Recommended)')),
          P(className: 'text-gray-400 mb-4',
              child: Text('For production deployments, use Docker Compose for easier management and automatic restarts:')),
          Div(
              className:
                  'rounded-xl bg-[#0d0d0d] border border-white/10 p-6 overflow-x-auto',
              children: [
                Pre(child:
                  Code(className: 'text-sm text-gray-300 whitespace-pre',
                      child: Text(
                          'services:\n'
                          '  omnius:\n'
                          '    image: ghcr.io/omnius-stream/server:latest\n'
                          '    ports:\n'
                          '      - "8080:8080"\n'
                          '    environment:\n'
                          '      LICENSE_KEY: YOUR_LICENSE_KEY\n'
                          '      ADMIN_PASSWORD: your_secure_password\n'
                          '    volumes:\n'
                          '      - omnius-data:/app/data\n'
                          '    restart: unless-stopped\n'
                          '\n'
                          'volumes:\n'
                          '  omnius-data:'))),
              ]),
          P(className: 'text-gray-400 mt-4',
              child: Text('Save this as docker-compose.yml and run: docker-compose up -d')),
        ]),
      ]),

      // Environment Variables
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('3. Environment Variables')),
          P(className: 'text-gray-400 mb-6',
              child: Text('Configure your server with these environment variables:')),
          Div(
              className:
                  'rounded-xl bg-[#0d0d0d] border border-white/10 overflow-hidden',
              children: [
                Table(className: 'w-full text-sm', children: [
                  Thead(child:
                    Tr(className: 'border-b border-white/10', children: [
                      Th(
                          className:
                              'text-left px-6 py-3 text-gray-400 font-medium',
                          child: Text('Variable')),
                      Th(
                          className:
                              'text-left px-6 py-3 text-gray-400 font-medium',
                          child: Text('Default')),
                      Th(
                          className:
                              'text-left px-6 py-3 text-gray-400 font-medium',
                          child: Text('Description')),
                    ]),
                  ),
                  Tbody(children: [
                    _envRow('LICENSE_KEY', '(empty)',
                        'Your Omnius license key. Without it, only the admin panel works - JSON APIs are disabled.'),
                    _envRow('ADMIN_PASSWORD', 'admin',
                        'Password for the admin panel at /admin'),
                    _envRow('PORT', '8080', 'HTTP port'),
                    _envRow('DATABASE_PATH', './data/omnius.db',
                        'Path to SQLite database'),
                  ]),
                ]),
              ]),
        ]),
      ]),

      // Without a License
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('4. Without a License')),
          Div(
              className:
                  'rounded-xl bg-primary-500/5 border border-primary-500/20 p-6',
              children: [
                P(className: 'text-gray-300 mb-4',
                    child: Text(
                        'You can run Omnius without a LICENSE_KEY, but with limited functionality:')),
                Div(className: 'space-y-3 mb-6', children: [
                  Div(className: 'flex items-start gap-3', children: [
                    Span(className: 'text-green-500 mt-1', child: Text('✓')),
                    Span(className: 'text-gray-300',
                        child: Text(
                            'The admin panel at /admin works fully - manage your movie catalog, series, live streams, and settings')),
                  ]),
                  Div(className: 'flex items-start gap-3', children: [
                    Span(className: 'text-red-500 mt-1', child: Text('✗')),
                    Span(className: 'text-gray-300',
                        child: Text(
                            'JSON API endpoints (/api/v2/*.json) are disabled - returns 403 with error message')),
                  ]),
                  Div(className: 'flex items-start gap-3', children: [
                    Span(className: 'text-red-500 mt-1', child: Text('✗')),
                    Span(className: 'text-gray-300',
                        child: Text(
                            'Client apps (Android TV, macOS) cannot connect to the server')),
                  ]),
                ]),
                P(className: 'text-sm text-gray-400',
                    child: Text(
                        'Purchase a license at /pricing to enable the full API and client app connectivity.')),
              ]),
        ]),
      ]),

      // Try the Demo
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('5. Try the Demo')),
          Div(
              className:
                  'rounded-xl bg-white/5 border border-white/10 p-6',
              children: [
                P(className: 'text-gray-300 mb-4',
                    child: Text(
                        'Want to explore the admin panel before deploying your own instance?')),
                P(className: 'text-gray-400 mb-4',
                    child: Text(
                        'We have a live demo instance running without a license key so you can see how the admin panel works:')),
                A(
                  href: 'https://demo.omnius.lol',
                  target: Target.blank,
                  className:
                      'inline-flex items-center gap-2 px-6 py-3 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                  children: [
                    Text('Visit Demo Instance'),
                    Span(child: Text('→')),
                  ],
                ),
                P(className: 'text-xs text-gray-500 mt-4',
                    child: Text(
                        'Note: The demo runs without a license, so API endpoints will return 403 errors.')),
              ]),
        ]),
      ]),

      // After Setup
      Section(className: 'py-12 bg-[#141414]', children: [
        Div(className: 'max-w-4xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('6. After Setup')),
          Div(className: 'space-y-6', children: [
            Div(className: 'flex gap-4', children: [
              Div(
                  className:
                      'flex-shrink-0 w-8 h-8 rounded-full bg-primary-500/10 flex items-center justify-center',
                  child: Span(
                      className: 'text-primary-500 font-bold text-sm',
                      child: Text('1'))),
              Div(className: 'flex-1', children: [
                H3(className: 'text-lg font-semibold text-white mb-2',
                    child: Text('Access the Admin Panel')),
                P(className: 'text-gray-400',
                    child: Text(
                        'Navigate to http://your-server:8080/admin and login with your ADMIN_PASSWORD.')),
              ]),
            ]),
            Div(className: 'flex gap-4', children: [
              Div(
                  className:
                      'flex-shrink-0 w-8 h-8 rounded-full bg-primary-500/10 flex items-center justify-center',
                  child: Span(
                      className: 'text-primary-500 font-bold text-sm',
                      child: Text('2'))),
              Div(className: 'flex-1', children: [
                H3(className: 'text-lg font-semibold text-white mb-2',
                    child: Text('Add Content')),
                P(className: 'text-gray-400',
                    child: Text(
                        'Use the admin panel to add movies, series, and live streams to your server.')),
              ]),
            ]),
            Div(className: 'flex gap-4', children: [
              Div(
                  className:
                      'flex-shrink-0 w-8 h-8 rounded-full bg-primary-500/10 flex items-center justify-center',
                  child: Span(
                      className: 'text-primary-500 font-bold text-sm',
                      child: Text('3'))),
              Div(className: 'flex-1', children: [
                H3(className: 'text-lg font-semibold text-white mb-2',
                    child: Text('Configure Client Apps')),
                P(className: 'text-gray-400',
                    child: Text(
                        'Point your Android TV or macOS client apps to your server URL (e.g., http://your-server:8080).')),
              ]),
            ]),
            Div(className: 'flex gap-4', children: [
              Div(
                  className:
                      'flex-shrink-0 w-8 h-8 rounded-full bg-primary-500/10 flex items-center justify-center',
                  child: Span(
                      className: 'text-primary-500 font-bold text-sm',
                      child: Text('4'))),
              Div(className: 'flex-1', children: [
                H3(className: 'text-lg font-semibold text-white mb-2',
                    child: Text('License Validation')),
                P(className: 'text-gray-400',
                    child: Text(
                        'The server validates your license every 6 hours via heartbeat. Ensure your server has internet connectivity.')),
              ]),
            ]),
          ]),
        ]),
      ]),

      // Bottom CTA
      Section(className: 'py-20 text-center', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(className: 'text-3xl font-bold text-white mb-4',
              child: Text('Need a License?')),
          P(className: 'text-gray-400 mb-8',
              child: Text(
                  'Purchase a license to unlock the full API and enable client app connectivity.')),
          Link(
            to: '/pricing',
            child: Span(
                className:
                    'inline-block px-8 py-3.5 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                child: Text('View Pricing →')),
          ),
        ]),
      ]),
    ]);
  }

  Component _envRow(String variable, String defaultValue, String description) {
    return Tr(className: 'border-b border-white/5', children: [
      Td(className: 'px-6 py-3 text-primary-500 font-mono text-xs',
          child: Text(variable)),
      Td(className: 'px-6 py-3 text-gray-300 font-mono text-xs',
          child: Text(defaultValue)),
      Td(className: 'px-6 py-3 text-gray-400 text-sm',
          child: Text(description)),
    ]);
  }
}
