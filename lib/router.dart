import "package:amaterasu/core/presentation/splash_screen.dart";
import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/accounts/presentation/account_switcher_screen.dart";
import "package:amaterasu/features/accounts/presentation/twitch_authorization_web_view.dart";
import "package:amaterasu/features/home/presentation/home_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "router.g.dart";

@riverpod
GoRouter router(RouterRef ref) {
  final listenable = _RouteRefreshListenable();
  ref.listen(authNotifierProvider, (_, __) {
    listenable.notify();
  });

  return GoRouter(
    initialLocation: "/splash",
    refreshListenable: listenable,
    routes: [
      GoRoute(path: "/splash", name: "splash", builder: (_, __) => const SplashScreen()),
      GoRoute(path: "/", name: "home", builder: (_, __) => const HomeScreen()),
      GoRoute(path: "/accounts", name: "accounts", builder: (_, __) => const AccountSwitcherScreen(), routes: [
        GoRoute(
          path: "auth",
          name: "auth",
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const TwitchAuthorizationWebView(),
          ),
        ),
      ]),
    ],
    redirect: (context, state) async {
      final authState = ref.read(authNotifierProvider);
      if (authState.isLoading) return null;

      final isAuthenticated = authState.valueOrNull != null;

      // If the user is authenticated, they should not be able to access the auth or splash screen.
      if (isAuthenticated && ["/splash", "/accounts", "/accounts/auth"].contains(state.location)) return "/";

      // If the user is not authenticated, they should be at the auth screen.
      if (!isAuthenticated && !state.location.startsWith("/accounts")) return "/accounts";

      return null;
    },
  );
}

class _RouteRefreshListenable extends Listenable {
  VoidCallback? _listener;
  @override
  void addListener(VoidCallback listener) {
    _listener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _listener = null;
  }

  void notify() {
    _listener?.call();
  }
}
