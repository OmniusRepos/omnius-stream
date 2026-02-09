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
              child: Text('Deploy in Minutes')),
          P(className: 'text-xl text-gray-400',
              child: Text(
                  'Get your Omnius streaming server running with Docker.')),
        ]),
      ]),

      // Steps Overview
      Section(className: 'py-12', children: [
        Div(className: 'max-w-4xl mx-auto px-4 grid md:grid-cols-3 gap-8', children: [
          _step('1', 'Get License',
              'Purchase a plan and receive your OMNI-XXXX-XXXX-XXXX-XXXX license key.'),
          _step('2', 'Deploy Server',
              'Run a single Docker command with your license key to start the server.'),
          _step('3', 'Go Live',
              'Configure the Android TV app to point at your server URL.'),
        ]),
      ]),

      // Docker Command
      Section(className: 'py-12', children: [
        Div(className: 'max-w-3xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('Docker Deployment')),
          Div(
              className:
                  'rounded-xl bg-[#1a1a1a] border border-white/10 p-6 overflow-x-auto',
              children: [
                Pre(child:
                  Code(className: 'text-sm text-gray-300 whitespace-pre',
                      child: Text(
                          'docker run -d \\\n'
                          '  --name omnius \\\n'
                          '  -p 8080:8080 \\\n'
                          '  -e LICENSE_KEY=OMNI-XXXX-XXXX-XXXX-XXXX \\\n'
                          '  -e ADMIN_PASSWORD=your_admin_password \\\n'
                          '  -e PORT=8080 \\\n'
                          '  -v omnius-data:/app/data \\\n'
                          '  ghcr.io/omnius-stream/server:latest'))),
              ]),
        ]),
      ]),

      // Environment Variables
      Section(className: 'py-12', children: [
        Div(className: 'max-w-3xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('Environment Variables')),
          Div(
              className:
                  'rounded-xl bg-[#1a1a1a] border border-white/10 overflow-hidden',
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
                          child: Text('Required')),
                      Th(
                          className:
                              'text-left px-6 py-3 text-gray-400 font-medium',
                          child: Text('Description')),
                    ]),
                  ),
                  Tbody(children: [
                    _envRow('LICENSE_KEY', 'Yes',
                        'Your Omnius license key (OMNI-XXXX-XXXX-XXXX-XXXX)'),
                    _envRow('ADMIN_PASSWORD', 'No',
                        'Password for the admin panel (default: admin)'),
                    _envRow('PORT', 'No', 'Server port (default: 8080)'),
                  ]),
                ]),
              ]),
        ]),
      ]),

      // Demo Mode
      Section(className: 'py-12', children: [
        Div(className: 'max-w-3xl mx-auto px-4', children: [
          Div(
              className:
                  'rounded-xl bg-primary-500/5 border border-primary-500/20 p-6',
              children: [
                H3(className: 'text-lg font-semibold text-white mb-3',
                    child: Text('Demo Mode')),
                P(className: 'text-sm text-gray-400 mb-4',
                    child: Text(
                        'Running without a license key starts the server in demo mode with limited functionality:')),
                Ul(className: 'space-y-2 text-sm text-gray-400', children: [
                  Li(child: Text('\u2022 10 movies max')),
                  Li(child: Text('\u2022 2 series max')),
                  Li(child: Text('\u2022 No live channels')),
                  Li(child: Text('\u2022 Watermark on player')),
                ]),
              ]),
        ]),
      ]),

      // Client Apps
      Section(className: 'py-12', children: [
        Div(className: 'max-w-3xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white mb-6',
              child: Text('Client Apps')),
          Div(className: 'grid md:grid-cols-2 gap-6', children: [
            Div(
                className: 'p-6 rounded-xl bg-white/5 border border-white/10',
                children: [
                  H3(className: 'text-lg font-semibold text-white mb-2',
                      child: Text('Android TV')),
                  P(className: 'text-sm text-gray-400',
                      child: Text(
                          'Jetpack Compose app optimized for TV with D-pad navigation, ExoPlayer, and torrent streaming.')),
                ]),
            Div(
                className: 'p-6 rounded-xl bg-white/5 border border-white/10',
                children: [
                  H3(className: 'text-lg font-semibold text-white mb-2',
                      child: Text('macOS')),
                  P(className: 'text-sm text-gray-400',
                      child: Text(
                          'Native macOS app for desktop streaming with full feature parity.')),
                ]),
          ]),
        ]),
      ]),

      // Bottom CTA
      Section(className: 'py-20 text-center', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(className: 'text-3xl font-bold text-white mb-4',
              child: Text("Don't Have a License Yet?")),
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

  Component _envRow(String variable, String required, String description) {
    return Tr(className: 'border-b border-white/5', children: [
      Td(className: 'px-6 py-3 text-primary-500 font-mono text-xs',
          child: Text(variable)),
      Td(className: 'px-6 py-3 text-gray-300',
          child: Text(required)),
      Td(className: 'px-6 py-3 text-gray-400',
          child: Text(description)),
    ]);
  }
}
