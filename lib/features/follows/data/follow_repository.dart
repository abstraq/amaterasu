import "package:amaterasu/features/follows/data/sources/helix_follows_data_source.dart";
import "package:amaterasu/features/follows/data/sources/local_follows_data_source.dart";
import "package:amaterasu/features/follows/domain/follow_connection.dart";
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

  Future<List<FollowConnection>> fetchUserTwitchFollows(final userId, {int first = 100, String? cursor}) async {
    final follows = await _api.fetchUserFollows(userId, first: first, cursor: cursor);
    return follows.data;
  }

  Future<List<FollowConnection>> fetchUserLocalFollows(final userId) async {
    return [];
  }

  Future<void> addLocalFollow(final FollowConnection follow) async {}

  Future<void> removeLocalFollow(final userId) async {}
}

@riverpod
FollowRepository followRepository(FollowRepositoryRef ref) {
  final api = ref.watch(helixFollowsDataSourceProvider);
  final local = ref.watch(localFollowsDataSourceProvider);
  return FollowRepository(api: api, local: local);
}

@riverpod
Future<List<FollowConnection>> follows(FollowsRef ref, final String userId) async {
  final follows = await ref.watch(followRepositoryProvider).fetchUserTwitchFollows(userId);
  return follows;
}
