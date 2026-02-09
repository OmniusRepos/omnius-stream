import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;

class TermsPage extends StatelessComponent {
  const TermsPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'py-24 px-4', children: [
      Div(className: 'max-w-3xl mx-auto', children: [
        H1(className: 'text-4xl font-bold text-white mb-8',
            child: Text('Terms of Service')),
        P(className: 'text-sm text-gray-500 mb-8',
            child: Text('Last updated: January 2026')),
        Div(className: 'space-y-8 text-gray-300 text-sm leading-relaxed', children: [
          _section('1. License Grant', [
            'Omnius grants you a non-exclusive, non-transferable license to use the Omnius streaming platform software according to your purchased plan.',
            'Personal licenses allow 1 deployment for personal, non-commercial use.',
            'Business licenses allow up to 5 deployments with commercial use rights.',
            'Enterprise licenses are custom agreements with unlimited deployments.',
          ]),
          _section('2. License Validation', [
            'The software requires license validation via our license server.',
            'On first activation, the server registers a machine fingerprint (hashed UUID + hostname).',
            'The server sends periodic heartbeats every 6 hours to verify the license.',
            'If validation fails, a 7-day grace period allows continued operation.',
            'After the grace period, the server enters demo mode with limited functionality.',
          ]),
          _section('3. Demo Mode Limitations', [
            'Running without a valid license or after grace period expiry limits the server to:',
            '\u2022 10 movies maximum',
            '\u2022 2 series maximum',
            '\u2022 No live TV channels',
            '\u2022 Watermark on video player',
          ]),
          _section('4. Restrictions', [
            'You may NOT share your license key with unauthorized parties.',
            'You may NOT circumvent, disable, or interfere with the license validation system.',
            'You may NOT reverse engineer, decompile, or disassemble the software.',
            'You may NOT redistribute or resell the software or license keys.',
          ]),
          _section('5. Payment', [
            'All payments are processed through Paddle, our merchant of record.',
            'Prices are one-time payments with no recurring fees.',
            'All applicable taxes are handled by Paddle.',
          ]),
          _section('6. Refund Policy', [
            'We offer a 14-day money-back guarantee from the date of purchase.',
            'Refund requests must be sent to hello@omnius.stream.',
            'See our Refund Policy page for full details and conditions.',
          ]),
          _section('7. Updates', [
            'All updates within the same major version are included in your purchase.',
            'New major versions may require a separate purchase or upgrade fee.',
          ]),
          _section('8. Support', [
            'Personal plan: Community support via documentation.',
            'Business plan: Priority email support.',
            'Enterprise plan: Dedicated support as per agreement.',
          ]),
          _section('9. Content Responsibility', [
            'Omnius is a self-hosted platform. You are solely responsible for the content you host and distribute.',
            'We do not host, store, or have access to your content catalog.',
            'You must comply with all applicable laws regarding the content you serve.',
          ]),
          _section('10. Disclaimer of Warranties', [
            'THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.',
            'WE DO NOT WARRANT THAT THE SOFTWARE WILL BE ERROR-FREE OR UNINTERRUPTED.',
          ]),
          _section('11. Limitation of Liability', [
            'IN NO EVENT SHALL OMNIUS BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES.',
            'OUR TOTAL LIABILITY SHALL NOT EXCEED THE AMOUNT YOU PAID FOR THE LICENSE.',
          ]),
          _section('12. Contact', [
            'For questions about these terms, contact us at hello@omnius.stream.',
          ]),
        ]),
      ]),
    ]);
  }

  Component _section(String title, List<String> paragraphs) {
    return Div(children: [
      H2(className: 'text-xl font-semibold text-white mb-3',
          child: Text(title)),
      for (final paragraph in paragraphs)
        P(className: 'text-gray-400 mb-2',
            child: Text(paragraph)),
    ]);
  }
}
