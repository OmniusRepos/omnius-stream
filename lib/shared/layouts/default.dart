import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import '../components/site_header.dart';
import '../components/site_footer.dart';

class DefaultLayout extends StatelessComponent {
  final Component child;
  const DefaultLayout({super.key, required this.child});

  @override
  Component build(BuildContext context) {
    return Div(className: 'min-h-screen bg-[#141414] flex flex-col', children: [
      const SiteHeader(),
      Div(className: 'flex-1 pt-16', child: child),
      const SiteFooter(),
    ]);
  }
}
