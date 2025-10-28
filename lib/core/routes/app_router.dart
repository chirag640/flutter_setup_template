import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// Provides the [GoRouter] instance wired to Riverpod so navigation updates
/// react properly to state changes like auth or locale.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: HomePage.routePath,
    routes: <RouteBase>[
      GoRoute(
        name: HomePage.routeName,
        path: HomePage.routePath,
        pageBuilder: (context, state) =>
            const NoTransitionPage<void>(child: HomePage()),
        routes: <RouteBase>[
          GoRoute(
            name: WidgetsRoutePage.routeName,
            path: WidgetsRoutePage.routeSegment,
            pageBuilder: (context, state) =>
                const MaterialPage<void>(child: WidgetsRoutePage()),
          ),
        ],
      ),
      GoRoute(
        name: LoginPage.routeName,
        path: LoginPage.routePath,
        pageBuilder: (context, state) =>
            const MaterialPage<void>(child: LoginPage()),
      ),
      GoRoute(
        name: ProfilePage.routeName,
        path: ProfilePage.routePath,
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId'] ?? 'unknown';
          return MaterialPage<void>(child: ProfilePage(userId: userId));
        },
      ),
    ],
    redirect: (context, state) {
      final bool isLoggingIn = state.fullPath == LoginPage.routePath;
      final bool hasError = authState.hasError;
      final bool isAuthenticated = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      if (hasError) {
        return isLoggingIn ? null : LoginPage.routePath;
      }

      if (!isAuthenticated) {
        return isLoggingIn ? null : LoginPage.routePath;
      }

      if (isLoggingIn) {
        return HomePage.routePath;
      }

      return null;
    },
    refreshListenable: refreshNotifier,
    errorPageBuilder: (context, state) =>
        MaterialPage<void>(child: _RouterErrorPage(exception: state.error)),
    observers: <NavigatorObserver>[
      // Placeholder for analytics observers.
    ],
  );
});

class _RouterErrorPage extends StatelessWidget {
  const _RouterErrorPage({this.exception});

  final Exception? exception;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation error')),
      body: Center(
        child: Text(
          exception?.toString() ?? 'Unknown navigation error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this._ref) {
    _subscription = _ref.listen<AsyncValue<User?>>(
      authStateProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<User?>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
