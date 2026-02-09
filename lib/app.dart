import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

// Generated routes
import '.generated/routes.dart' as generated;

// Shared
import 'shared/layouts/default.dart';
import 'shared/layouts/dashboard_layout.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    final routes = generated.generatedRoutes;

    final wrappedRoutes = routes.map((route) {
      // Routes under /app use the DashboardLayout
      final isDashboard = route.path.startsWith('/app');

      return Route(
        path: route.path,
        builder: (context, state) {
          final page = Builder(builder: (ctx) => route.builder!(ctx, state));
          if (isDashboard) {
            return DashboardLayout(child: page);
          }
          return DefaultLayout(child: page);
        },
      );
    }).toList();

    return Router(routes: wrappedRoutes);
  }
}
