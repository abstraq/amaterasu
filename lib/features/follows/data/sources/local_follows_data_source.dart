import "package:amaterasu/core/data/sqlite_database.dart";
import "package:amaterasu/features/follows/domain/follow.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:sqflite/sqflite.dart";

part "local_follows_data_source.g.dart";

class LocalFollowsDataSource {
  final Database _database;

  LocalFollowsDataSource(this._database);

  Future<int> insertFollow(final Follow follow) async {
    return _database.insert(
      twitchFollowsTableName,
      follow.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> bulkInsertFollows(final List<Follow> follows) async {
    return _database.transaction((txn) async {
      var count = 0;
      for (final follow in follows) {
        count += await txn.insert(
          twitchFollowsTableName,
          follow.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return count;
    });
  }

  Future<List<Follow>> fetchFollows(final String userId) async {
    final result = await _database.query(twitchFollowsTableName, where: "user_id = ?", whereArgs: [userId]);
    return result.map((e) => Follow.fromMap(e)).toList();
  }

  Future<int> deleteFollow({required String userId, required String broadcasterId}) async {
    return _database.delete(
      twitchFollowsTableName,
      where: "user_id = ? AND broadcaster_id = ?",
      whereArgs: [userId, broadcasterId],
    );
  }
}

@riverpod
LocalFollowsDataSource localFollowsDataSource(LocalFollowsDataSourceRef ref) {
  final database = ref.watch(databaseProvider);
  return LocalFollowsDataSource(database);
}
