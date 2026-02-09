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

      // Paddle.js
      script(src: 'https://cdn.paddle.com/paddle/v2/paddle.js'),
      script(content: '''
(function() {
  if (typeof Paddle === 'undefined') return;
  Paddle.Environment.set('sandbox');
  Paddle.Initialize({
    token: window.__PADDLE_CLIENT_TOKEN || 'test_token',
  });

  function openCheckout(priceId) {
    Paddle.Checkout.open({
      items: [{ priceId: priceId, quantity: 1 }],
      settings: { theme: 'dark' },
      customer: {},
      eventCallback: function(event) {
        if (event.name === 'checkout.completed') {
          var email = event.data?.customer?.email || '';
          window.location.href = '/success?email=' + encodeURIComponent(email);
        }
      },
    });
  }

  var personalBtn = document.getElementById('buy-personal');
  var businessBtn = document.getElementById('buy-business');
  var enterpriseBtn = document.getElementById('buy-enterprise');

  if (personalBtn) {
    personalBtn.addEventListener('click', function() {
      openCheckout(window.__PADDLE_PERSONAL_PRICE_ID || 'pri_personal');
    });
  }
  if (businessBtn) {
    businessBtn.addEventListener('click', function() {
      openCheckout(window.__PADDLE_BUSINESS_PRICE_ID || 'pri_business');
    });
  }
  if (enterpriseBtn) {
    enterpriseBtn.addEventListener('click', function() {
      openCheckout(window.__PADDLE_ENTERPRISE_PRICE_ID || 'pri_enterprise');
    });
  }
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
