import "dart:developer";

import "package:amaterasu/router.dart";
import "package:amaterasu/themes/default_theme.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logging/logging.dart";

/// Root widget of the application.
class AmaterasuApp extends ConsumerWidget {
  const AmaterasuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Give the status and navigation bar transparent background.
    const color = Colors.transparent;
    final overlayStyle = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: color, statusBarColor: color);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);

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

void _configureLogger() {
  Logger.root.onRecord.listen((record) {
    log(
      record.message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      name: record.loggerName,
      level: record.level.value,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureLogger();
  runApp(const ProviderScope(child: AmaterasuApp()));
}
