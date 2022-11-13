import "dart:async";

import "package:amaterasu/features/users/data/sources/helix_user_data_source.dart";
import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_repository.g.dart";

class UserRepository {
  final HelixUserDataSource _api;

  UserRepository({required HelixUserDataSource api}) : _api = api;

  Future<List<TwitchUser>> retrieveUsers(final List<String> userIds) async {
    final response = await _api.fetchUsers(userIds);
    return response.data;
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final api = ref.watch(helixUserDataSourceProvider);
  return UserRepository(api: api);
}

@riverpod
Future<Map<String, TwitchUser>> users(UsersRef ref, {required List<String> userIds, required Duration ttl}) async {
  final users = await ref.watch(userRepositoryProvider).retrieveUsers(userIds);

  final link = ref.keepAlive();
  final timer = Timer(ttl, link.close);
  ref.onDispose(timer.cancel);

  return {for (final user in users) user.id: user};
}
