import "package:amaterasu/features/authentication/presentation/auth_controller.dart";
import "package:amaterasu/features/authentication/presentation/auth_screen.dart";
import "package:amaterasu/features/home/presentation/home_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  ref.watch(authControllerProvider);
  final authController = ref.read(authControllerProvider.notifier);

  return GoRouter(
    navigatorKey: _key,
    initialLocation: "/splash",
    routes: [
      GoRoute(path: "/", name: "home", builder: (_, __) => const HomeScreen()),
      GoRoute(path: "/auth", name: "auth", builder: (_, __) => const AuthScreen()),
      GoRoute(path: "/splash", name: "splash", builder: (_, __) => const Center(child: CircularProgressIndicator())),
    ],
    redirect: (context, state) {
      if (authController.isLoading) return null;
      final isAuthenticated = authController.isAuthenticated;

      // If the user is at the splash screen and is authenticated, redirect to the home screen.
      // Otherwise, if the user is at the splash screen and is not authenticated, redirect to the auth screen.
      if (state.location == "/splash") {
        return isAuthenticated ? "/" : "/auth";
      }

      // If the user is at the auth screen and is authenticated, redirect to the home screen.
      // Otherwise, if the user is at the auth screen and is not authenticated, do nothing.
      if (state.location == "/auth") {
        return isAuthenticated ? "/" : null;
      }

      return isAuthenticated ? null : "/splash";
    },
  );
});
