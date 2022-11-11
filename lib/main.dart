import "dart:developer";

import "package:amaterasu/core/data/sqlite_database.dart";
import "package:amaterasu/router.dart";
import "package:amaterasu/themes/default_theme.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logging/logging.dart";
import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";

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

Future<Database> _openDatabase() async {
  final appSupportDir = await getApplicationSupportDirectory();
  final databasePath = path.join(appSupportDir.path, "storage.sqlite3");
  final database = openDatabase(databasePath, version: 1, onCreate: (db, version) async {
    await db.execute(
        "CREATE TABLE $twitchFollowsTableName (followed_at TEXT NOT NULL, from_id TEXT NOT NULL, to_id TEXT NOT NULL, PRIMARY KEY (from_id, to_id))");
  });
  return database;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureLogger();

  final database = await _openDatabase();

  runApp(ProviderScope(
    overrides: [databaseProvider.overrideWithValue(database)],
    child: const AmaterasuApp(),
  ));
}
