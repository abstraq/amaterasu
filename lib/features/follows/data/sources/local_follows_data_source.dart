import "package:amaterasu/core/data/sqlite_database.dart";
import "package:amaterasu/features/follows/domain/follow_connection.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:sqflite/sqflite.dart";

part "local_follows_data_source.g.dart";

class LocalFollowsDataSource {
  final Database _database;

  LocalFollowsDataSource(this._database);

  Future<int> insertFollow(final FollowConnection follow) async {
    return _database.insert(
      twitchFollowsTableName,
      follow.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FollowConnection>> fetchFollows(final String userId) async {
    final result = await _database.query(twitchFollowsTableName, where: "from_id = ?", whereArgs: [userId]);
    return result.map((e) => FollowConnection.fromMap(e)).toList();
  }

  Future<int> deleteFollow({required String userId, required String broadcasterId}) async {
    return _database.delete(
      twitchFollowsTableName,
      where: "from_id = ? AND to_id = ?",
      whereArgs: [userId, broadcasterId],
    );
  }
}

@riverpod
LocalFollowsDataSource localFollowsDataSource(LocalFollowsDataSourceRef ref) {
  final database = ref.watch(databaseProvider);
  return LocalFollowsDataSource(database);
}
