import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;

class PricingCard extends StatelessComponent {
  final String title;
  final String price;
  final String subtitle;
  final List<String> features;
  final bool isPopular;
  final String? buttonId;
  final String? buttonText;
  final String? href;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.features,
    this.isPopular = false,
    this.buttonId,
    this.buttonText,
    this.href,
  });

  @override
  Component build(BuildContext context) {
    final borderClass = isPopular
        ? 'bg-primary-500/10 border-2 border-primary-500'
        : 'bg-white/5 border border-white/10';
    final btnClass = isPopular
        ? 'bg-primary-500 text-white hover:bg-primary-600'
        : 'bg-white/10 text-white hover:bg-white/20';

    return Div(className: 'relative rounded-2xl p-8 $borderClass flex flex-col', children: [
      if (isPopular)
        Div(className: 'absolute -top-3 left-1/2 -translate-x-1/2', child:
          Span(className: 'px-3 py-1 bg-primary-500 text-white text-xs font-semibold rounded-full', child: Text('MOST POPULAR'))),
      H3(className: 'text-xl font-bold text-white mb-2', child: Text(title)),
      Div(className: 'mb-4', children: [
        Span(className: 'text-4xl font-extrabold text-white', child: Text(price)),
        if (price != 'Custom')
          Span(className: 'text-gray-400 text-sm ml-2', child: Text('one-time')),
      ]),
      P(className: 'text-gray-400 text-sm mb-6', child: Text(subtitle)),
      Div(className: 'flex-1 space-y-3 mb-8', children: [
        for (final feature in features)
          Div(className: 'flex items-start gap-2', children: [
            Span(className: 'text-primary-500 mt-0.5', child: Text('\u2713')),
            Span(className: 'text-gray-300 text-sm', child: Text(feature)),
          ]),
      ]),
      if (buttonId != null)
        Button(id: buttonId!, className: 'w-full py-3 px-6 rounded-lg font-semibold text-sm transition-colors $btnClass',
          child: Text(buttonText ?? 'Buy Now'))
      else if (href != null)
        A(href: href!, className: 'block w-full text-center py-3 px-6 rounded-lg font-semibold text-sm transition-colors bg-white/10 text-white hover:bg-white/20',
          child: Text(buttonText ?? 'Contact Sales')),
    ]);
  }
}
