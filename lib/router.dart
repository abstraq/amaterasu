import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/accounts/presentation/auth_screen.dart";
import "package:amaterasu/features/home/presentation/home_screen.dart";
import "package:amaterasu/features/splash/presentation/splash_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "router.g.dart";

final GlobalKey<NavigatorState> _key = GlobalKey();

@riverpod
GoRouter router(RouterRef ref) {
  final authNotifierState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _key,
    initialLocation: "/splash",
    routes: [
      GoRoute(path: "/", name: "home", builder: (_, __) => const HomeScreen()),
      GoRoute(path: "/auth", name: "auth", builder: (_, __) => const AuthScreen()),
      GoRoute(path: "/splash", name: "splash", builder: (_, __) => const SplashScreen()),
    ],
    redirect: (context, state) async {
      final currentAccount = authNotifierState.valueOrNull;
      final isAuthenticated = currentAccount != null;

      // If the user is authenticated, they should not be able to access the auth or splash screen.
      if (isAuthenticated && ["/splash", "/auth"].contains(state.location)) return "/";

      // If the user is not authenticated, they should be at the auth screen.
      if (!isAuthenticated && state.location != "/auth") return "/auth";

      return null;
    },
  );
}
