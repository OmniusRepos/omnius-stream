import 'dart:io';
import 'package:duxt/server.dart';
import 'package:shelf/shelf.dart' show Middleware, Handler, Request, Response;
import 'db.dart';
import 'api/auth.dart';
import 'api/licenses.dart';
import 'api/polar.dart';
import 'api/dashboard.dart';
import 'api/admin.dart';

void main() async {
  // Initialize ORM and run migrations
  await Db.init();

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 3001;

  final server = DuxtServer(
    port: port,
    middleware: [
      // Security: restrict CORS to our domain only
      cors(origins: ['https://omnius.stream']),
      // Security: rate limit 60 req/min per IP
      rateLimit(maxRequests: 60, window: Duration(minutes: 1)),
      // Security: 1 MB body limit
      bodyLimit(),
      // Security: 30s request timeout
      timeout(),
      // Parse JSON bodies
      jsonBody(),
      // Logger
      logger(),
      // Security headers (outermost on response — runs last, overwrites everything)
      _hardenHeaders(),
    ],
  );

  // Serve robots.txt and sitemap.xml
  server.get('/robots.txt', (req) {
    return Response.ok(
      'User-agent: *\n'
      'Allow: /\n'
      'Disallow: /admin\n'
      'Disallow: /api/\n'
      'Disallow: /app/\n'
      'Disallow: /auth/\n'
      '\n'
      'Sitemap: https://omnius.stream/sitemap.xml\n',
      headers: {'Content-Type': 'text/plain'},
    );
  });

  server.get('/sitemap.xml', (req) {
    final pages = ['', 'features', 'pricing', 'compare', 'technology', 'terms', 'privacy', 'refund'];
    final urls = pages.map((p) =>
      '  <url><loc>https://omnius.stream/$p</loc></url>'
    ).join('\n');
    return Response.ok(
      '<?xml version="1.0" encoding="UTF-8"?>\n'
      '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
      '$urls\n'
      '</urlset>\n',
      headers: {'Content-Type': 'application/xml'},
    );
  });

  // Register API routes
  registerAuthRoutes(server);
  registerLicensRoutes(server);
  registerPolarRoutes(server);
  registerDashboardRoutes(server);
  registerAdminRoutes(server);

  server.start();
}

/// Custom middleware: all security headers in one place
Middleware _hardenHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      final headers = Map<String, String>.from(response.headers);

      // Remove tech fingerprinting (shelf adds X-Powered-By)
      headers.remove('x-powered-by');
      headers.remove('X-Powered-By');

      // Remove deprecated X-XSS-Protection (CSP replaces it)
      headers.remove('x-xss-protection');
      headers.remove('X-XSS-Protection');

      // Standard security headers
      headers['X-Content-Type-Options'] = 'nosniff';
      headers['X-Frame-Options'] = 'DENY';
      headers['Referrer-Policy'] = 'strict-origin-when-cross-origin';

      // HSTS (2 years, include subdomains, preload)
      headers['Strict-Transport-Security'] =
          'max-age=63072000; includeSubDomains; preload';

      // Content Security Policy
      headers['Content-Security-Policy'] =
          "default-src 'self'; "
          "script-src 'self' 'unsafe-inline'; "
          "style-src 'self' 'unsafe-inline'; "
          "img-src 'self' data: https:; "
          "connect-src 'self' https://api.polar.sh";

      // Permissions Policy
      headers['Permissions-Policy'] =
          'camera=(), microphone=(), geolocation=()';

      return response.change(headers: headers);
    };
  };
}
