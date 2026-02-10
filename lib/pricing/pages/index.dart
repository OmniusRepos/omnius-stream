import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import '../../shared/components/pricing_card.dart';

class PricingPage extends StatelessComponent {
  const PricingPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(children: [
      // Hero
      Section(className: 'pt-24 pb-12 text-center px-4', children: [
        Div(className: 'max-w-3xl mx-auto', children: [
          H1(className: 'text-4xl md:text-5xl font-extrabold text-white mb-4',
              child: Text('Simple, One-Time Pricing')),
          P(className: 'text-xl text-gray-400',
              child: Text(
                  'No subscriptions. No hidden fees. Pay once, deploy forever.')),
        ]),
      ]),

      // Pricing Cards
      Section(className: 'py-12', children: [
        Div(
            className:
                'max-w-5xl mx-auto px-4 grid md:grid-cols-3 gap-8 items-start',
            children: [
              PricingCard(
                title: 'Personal',
                price: '\$99',
                subtitle: 'For trying out the platform',
                buttonId: 'buy-personal',
                buttonText: 'Buy Personal',
                features: [
                  '1 deployment license key',
                  'Server + Admin Panel',
                  'Android TV + macOS apps',
                  'Up to 100 content items',
                  'Community support (docs)',
                ],
                limitations: [
                  'No live streams',
                  'No P2P distribution',
                  'Personal use only',
                ],
              ),
              PricingCard(
                title: 'Business',
                price: '\$499',
                subtitle: 'Full platform, no restrictions',
                isPopular: true,
                buttonId: 'buy-business',
                buttonText: 'Buy Business',
                features: [
                  '5 deployment license keys',
                  'Unlimited content items',
                  'Live streams + EPG',
                  'P2P distribution',
                  'Priority email support',
                  'Commercial use allowed',
                  'All future updates included',
                ],
              ),
              PricingCard(
                title: 'Enterprise',
                price: '\$999',
                subtitle: 'White-label your own platform',
                buttonId: 'buy-enterprise',
                buttonText: 'Buy Enterprise',
                features: [
                  'Unlimited deployments',
                  'Everything in Business',
                  'White-label APK + server',
                  'Custom branding & logo',
                  'Dedicated support',
                  'Custom feature development',
                ],
              ),
            ]),
      ]),

      // FAQ
      Section(className: 'py-16', children: [
        Div(className: 'max-w-2xl mx-auto px-4', children: [
          H2(className: 'text-2xl font-bold text-white text-center mb-8',
              child: Text('Frequently Asked Questions')),
          Div(className: 'space-y-6', children: [
            _faq('Is this a subscription?',
                'No. All plans are one-time purchases. You own your license forever with no recurring fees.'),
            _faq('What happens after purchase?',
                'You receive a license key (OMNI-XXXX-XXXX-XXXX-XXXX) that you use to deploy your server via Docker.'),
            _faq('Can I get a refund?',
                'Yes. We offer a 14-day money-back guarantee. Contact hello@omnius.stream for refund requests.'),
            _faq('What\'s included in updates?',
                'All updates within the same major version are included. New major versions may require a separate purchase.'),
          ]),
        ]),
      ]),

      // Auth check + Polar checkout redirect
      script(content: '''
(function() {
  var checkoutUrl = 'https://buy.polar.sh/polar_cl_nshOK8uQLljxUrC1U0vAVcHSjW4CNlBt2KJYa13cWNh';
  var buttons = ['buy-personal', 'buy-business', 'buy-enterprise'];
  var userEmail = null;

  // Check if user is logged in
  fetch('/api/auth/me')
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.user && data.user.email) {
        userEmail = data.user.email;
      }
    })
    .catch(function() {});

  buttons.forEach(function(id) {
    var btn = document.getElementById(id);
    if (btn) {
      btn.addEventListener('click', function() {
        if (!userEmail) {
          // Not logged in — redirect to login with return URL
          window.location.href = '/auth/login?redirect=/pricing';
          return;
        }
        // Logged in — pass email to Polar checkout
        var url = checkoutUrl + '?customer_email=' + encodeURIComponent(userEmail);
        window.location.href = url;
      });
    }
  });
})();
      '''),
    ]);
  }

  Component _faq(String question, String answer) {
    return Div(
        className: 'p-5 rounded-xl bg-white/5 border border-white/10',
        children: [
          H3(className: 'text-base font-semibold text-white mb-2',
              child: Text(question)),
          P(className: 'text-sm text-gray-400 leading-relaxed',
              child: Text(answer)),
        ]);
  }
}
