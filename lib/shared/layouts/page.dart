import 'package:duxt_html/duxt_html.dart';
import 'package:duxt/content.dart';

class DefaultPageLayout extends PageLayoutBase {
  const DefaultPageLayout();

  @override
  String get name => 'default';

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final title = pageData['title'] as String? ?? 'Untitled';

    return Div(className: 'py-12 px-4', child:
      Div(className: 'max-w-3xl mx-auto', children: [
        H1(className: 'text-4xl font-bold text-white mb-8', child: Text(title)),
        Div(className: 'prose prose-invert prose-lg max-w-none [&_p]:!text-gray-100 [&_h2]:!text-primary-500 [&_h3]:!text-primary-500 [&_a]:!text-primary-500 [&_strong]:!text-white [&_code]:!text-primary-300 [&_code]:bg-gray-800 [&_code]:px-1.5 [&_code]:py-0.5 [&_code]:rounded [&_pre]:bg-gray-800 [&_li]:!text-gray-100', child: child),
      ]),
    );
  }
}
