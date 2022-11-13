import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/follows/data/follow_repository.dart";
import "package:amaterasu/features/follows/domain/follow.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "local_follows_notifier.g.dart";

@riverpod
class LocalFollowsNotifier extends _$LocalFollowsNotifier {
  @override
  Future<Map<String, Follow>> build() async {
    final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
    if (currentUserId == null) {
      return {};
    }

    final followRepository = ref.watch(followRepositoryProvider);
    final follows = await followRepository.fetchUserLocalFollows(currentUserId);
    return {for (final follow in follows) follow.broadcasterId: follow};
  }

  Future<void> addFollow(final String broadcasterId, {DateTime? followedAt}) async {
    state = const AsyncLoading();
    final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
    if (currentUserId == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      final followRepository = ref.watch(followRepositoryProvider);
      final follow = Follow(
        followedAt: followedAt ?? DateTime.now().toUtc(),
        userId: currentUserId,
        broadcasterId: broadcasterId,
      );
      await followRepository.addLocalFollow(follow);
      return {...state.requireValue, follow.broadcasterId: follow};
    });
  }

  Future<void> addFollows(final List<Follow> follows) async {
    state = const AsyncLoading();
    final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
    if (currentUserId == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      final followRepository = ref.watch(followRepositoryProvider);
      await followRepository.addLocalFollows(follows);
      return {...state.requireValue, for (final follow in follows) follow.broadcasterId: follow};
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
