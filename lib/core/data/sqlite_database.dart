import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:sqflite/sqflite.dart";

part "sqlite_database.g.dart";

const String twitchFollowsTableName = "twitch_follows";

@riverpod
Database database(DatabaseRef ref) => throw UnimplementedError();
