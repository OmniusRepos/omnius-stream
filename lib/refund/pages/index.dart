import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;

class RefundPage extends StatelessComponent {
  const RefundPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(className: 'py-24 px-4', children: [
      Div(className: 'max-w-3xl mx-auto', children: [
        H1(className: 'text-4xl font-bold text-white mb-8',
            child: Text('Refund Policy')),
        P(className: 'text-sm text-gray-500 mb-8',
            child: Text('Last updated: January 2026')),

        // 14-day guarantee highlight
        Div(
            className:
                'rounded-2xl bg-primary-500/5 border border-primary-500/20 p-6 mb-8',
            children: [
              H2(className: 'text-xl font-bold text-white mb-2',
                  child: Text('14-Day Money-Back Guarantee')),
              P(className: 'text-gray-400',
                  child: Text(
                      'If you\'re not satisfied with Omnius, you can request a full refund within 14 days of your purchase. No questions asked.')),
            ]),

        Div(className: 'space-y-8 text-gray-300 text-sm leading-relaxed', children: [
          _section('How to Request a Refund', [
            'Send an email to hello@omnius.stream with your purchase email and order details.',
            'Refund requests must be made within 14 days of the original purchase date.',
            'Polar.sh (our payment processor) will process the refund to your original payment method.',
            'Refunds typically appear within 5\u201310 business days.',
          ]),
          _section('Refund Conditions', [
            'A refund may be denied if:',
            '\u2022 The request is made after 14 days from the purchase date',
            '\u2022 Substantial deployment in a production environment has occurred',
            '\u2022 The license key has been shared with unauthorized parties',
            '\u2022 There is evidence of abuse of the refund policy',
          ]),
          _section('What Happens After a Refund', [
            'Your license key will be deactivated immediately upon refund.',
            'Any running servers using the refunded license will enter demo mode.',
            'You will lose access to priority support (Business/Enterprise plans).',
          ]),
          _section('Partial Refunds', [
            'We do not offer partial refunds. Refunds are processed for the full purchase amount.',
          ]),
          _section('Enterprise Refunds', [
            'Enterprise plan refunds are handled on a case-by-case basis.',
            'Contact hello@omnius.stream to discuss your specific situation.',
          ]),
          _section('Contact', [
            'For refund requests or questions, email hello@omnius.stream.',
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
