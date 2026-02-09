import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;

class PrivacyPage extends StatelessComponent {
  const PrivacyPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'py-24 px-4', children: [
      Div(className: 'max-w-3xl mx-auto', children: [
        H1(className: 'text-4xl font-bold text-white mb-8',
            child: Text('Privacy Policy')),
        P(className: 'text-sm text-gray-500 mb-8',
            child: Text('Last updated: January 2026')),
        Div(className: 'space-y-8 text-gray-300 text-sm leading-relaxed', children: [
          _section('1. Data We Collect', [
            'When you purchase and use Omnius, we collect the following data:',
            '\u2022 Email address and name (during purchase/registration)',
            '\u2022 License key (generated upon purchase)',
            '\u2022 Machine fingerprint (hashed UUID + hostname, during validation)',
            '\u2022 IP address (during license validation requests)',
            '\u2022 Server version (during heartbeat checks)',
          ]),
          _section('2. Data We Do NOT Collect', [
            'We do NOT collect or have access to:',
            '\u2022 Your content catalog or media library',
            '\u2022 User viewing habits or watch history',
            '\u2022 Database contents on your server',
            '\u2022 Admin credentials or passwords',
            '\u2022 Any data from your end users',
          ]),
          _section('3. How We Use Your Data', [
            'License validation: Your license key and machine fingerprint are used to verify your license status.',
            'Communication: Your email is used to send purchase confirmations and important product updates.',
            'Support: Your contact information is used to respond to support requests.',
          ]),
          _section('4. Data Security', [
            'All communication with our license server uses HTTPS encryption.',
            'Machine fingerprints are one-way hashed \u2014 we never store raw device identifiers.',
            'Passwords are hashed using SHA-256 with salt before storage.',
          ]),
          _section('5. Data Retention', [
            'Active licenses: Data retained for the lifetime of the license.',
            'IP address logs: Retained for 90 days, then anonymized.',
            'Expired/revoked licenses: Data retained for 1 year for dispute resolution.',
            'Stale deployments: Cleaned up after 24 hours without a heartbeat.',
          ]),
          _section('6. Third-Party Sharing', [
            'We do NOT sell or share your data with third parties.',
            'Payment processing is handled by Polar.sh, which has its own privacy policy.',
            'We may disclose data if required by law or to protect our legal rights.',
          ]),
          _section('7. Your Rights', [
            'You have the right to:',
            '\u2022 Access your personal data',
            '\u2022 Request correction of inaccurate data',
            '\u2022 Request deletion of your data',
            '\u2022 Export your data in a portable format',
            'To exercise these rights, contact hello@omnius.stream.',
          ]),
          _section('8. Contact', [
            'For privacy-related questions, contact us at hello@omnius.stream.',
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
