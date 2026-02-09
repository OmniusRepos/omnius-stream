import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:duxt/duxt.dart';
import 'app.dart';

import 'main.server.options.dart';

void main() {
  Api.configure(baseUrl: '/api');
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(Document(
    title: 'Omnius - Self-Hosted Streaming Platform',
    head: [
      link(href: '/styles.css', rel: 'stylesheet'),
      link(
        href: 'https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600;700;800&display=swap',
        rel: 'stylesheet',
      ),
      link(rel: 'icon', href: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32"><rect width="32" height="32" rx="6" fill="%23141414"/><text x="16" y="23" font-size="20" font-weight="bold" fill="%23FF2D55" text-anchor="middle" font-family="sans-serif">O</text></svg>'),
    ],
    body: App(),
  ));
}
