import "dart:developer";

import "package:amaterasu/routing/router.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

void main() {
  runApp(const ProviderScope(child: AmaterasuApp()));
}

/// Root widget of the application.
class AmaterasuApp extends ConsumerWidget {
  const AmaterasuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    log("Rebuilt App ${DateTime.now()}");
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Amaterasu",
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
