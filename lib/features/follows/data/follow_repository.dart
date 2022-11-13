import "dart:async";

import "package:amaterasu/features/follows/data/sources/helix_follows_data_source.dart";
import "package:amaterasu/features/follows/data/sources/local_follows_data_source.dart";
import "package:amaterasu/features/follows/domain/follow.dart";
import "package:amaterasu/features/users/data/user_repository.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "follow_repository.g.dart";

class FollowRepository {
  final HelixFollowsDataSource _api;
  final LocalFollowsDataSource _local;

  FollowRepository({
    required HelixFollowsDataSource api,
    required LocalFollowsDataSource local,
  })  : _api = api,
        _local = local;

  Future<Map<String, Follow>> fetchUserTwitchFollows(final userId, {int first = 100, String? cursor}) async {
    final response = await _api.fetchUserFollows(userId, first: first, cursor: cursor);
    final follows = {
      for (final relationship in response.data)
        relationship.toId: Follow(
          userId: relationship.fromId,
          broadcasterId: relationship.toId,
          followedAt: relationship.followedAt,
        )
    };

    if (response.pagination.cursor == null) return follows;

    /// Recursively fetch all the pages of follows.
    final nextFollows = await fetchUserTwitchFollows(userId, first: first, cursor: response.pagination.cursor);
    return {...follows, ...nextFollows};
  }

  Future<List<Follow>> fetchUserLocalFollows(final userId) async => _local.fetchFollows(userId);

  Future<void> addLocalFollow(final Follow follow) async => _local.insertFollow(follow);

  Future<void> addLocalFollows(final List<Follow> follows) async => _local.bulkInsertFollows(follows);

  Future<void> removeLocalFollow({required String userId, required String broadcasterId}) async {
    await _local.deleteFollow(userId: userId, broadcasterId: broadcasterId);
  }
}

@riverpod
FollowRepository followRepository(FollowRepositoryRef ref) {
  final api = ref.watch(helixFollowsDataSourceProvider);
  final local = ref.watch(localFollowsDataSourceProvider);
  return FollowRepository(api: api, local: local);
}

@riverpod
Future<Map<String, Follow>> twitchFollows(TwitchFollowsRef ref, final String userId) async {
  const ttl = Duration(minutes: 2);

  var follows = await ref.watch(followRepositoryProvider).fetchUserTwitchFollows(userId);
  final users = await ref.watch(usersProvider(ttl: ttl, userIds: follows.keys.toList()).future);
  follows = {
    for (final follow in follows.values) follow.broadcasterId: follow.copyWith(broadcaster: users[follow.broadcasterId])
  };

  final link = ref.keepAlive();
  final timer = Timer(ttl, link.close);
  ref.onDispose(timer.cancel);

  return follows;
}
