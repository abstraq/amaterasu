import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/follows/data/follow_repository.dart";
import "package:amaterasu/features/follows/domain/follow_connection.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "local_follows_notifier.g.dart";

@riverpod
class LocalFollowsNotifier extends _$LocalFollowsNotifier {
  @override
  Future<Map<String, FollowConnection>> build() async {
    final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
    if (currentUserId == null) {
      return {};
    }

    final followRepository = ref.watch(followRepositoryProvider);
    final follows = await followRepository.fetchUserLocalFollows(currentUserId);
    return {for (final follow in follows) follow.toId: follow};
  }

  Future<void> addFollow(final String broadcasterId) async {
    state = const AsyncLoading();
    final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
    if (currentUserId == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      final followRepository = ref.watch(followRepositoryProvider);
      final follow = FollowConnection(followedAt: DateTime.now().toUtc(), fromId: currentUserId, toId: broadcasterId);
      await followRepository.addLocalFollow(follow);
      return {...state.requireValue, follow.toId: follow};
    });
  }

  Future<void> removeFollow(final String broadcasterId) async {
    state = const AsyncLoading();
    final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
    if (currentUserId == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      final followRepository = ref.watch(followRepositoryProvider);
      await followRepository.removeLocalFollow(userId: currentUserId, broadcasterId: broadcasterId);
      return {...state.requireValue}..remove(broadcasterId);
    });
  }
}
