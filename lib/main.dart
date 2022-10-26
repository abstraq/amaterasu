import "dart:developer";

import "package:amaterasu/router.dart";
import "package:amaterasu/themes/default_theme.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    log("didUpdateProvider: $provider $previousValue -> $newValue");
  }
}

void main() {
  runApp(ProviderScope(observers: [LoggerObserver()], child: const AmaterasuApp()));
}

/// Root widget of the application.
class AmaterasuApp extends ConsumerWidget {
  const AmaterasuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: const Color(0x00000000),
      statusBarColor: const Color(0x00000000),
    ));
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Amaterasu",
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      routerConfig: router,
    );
  }
}
