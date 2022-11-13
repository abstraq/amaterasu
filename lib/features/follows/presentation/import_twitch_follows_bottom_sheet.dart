import "dart:async";

import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/follows/application/local_follows_notifier.dart";
import "package:amaterasu/features/follows/data/follow_repository.dart";
import "package:amaterasu/features/follows/presentation/import_twitch_follows_list.dart";
import "package:amaterasu/features/follows/presentation/import_twitch_follows_list_tile_skeleton.dart";
import "package:amaterasu/features/users/data/user_repository.dart";
import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "import_twitch_follows_bottom_sheet.g.dart";

class ImportTwitchFollowsBottomSheet extends ConsumerWidget {
  const ImportTwitchFollowsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followedUsersValue = ref.watch(_helixFollowedUsersProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: followedUsersValue.valueOrNull != null && followedUsersValue.valueOrNull!.isNotEmpty
                  ? () async => ref
                      .read(localFollowsNotifierProvider.notifier)
                      .addFollows(followedUsersValue.valueOrNull!.map((user) => user.id).toList())
                  : null,
              child: const Text("Import All")),
          Expanded(
            child: followedUsersValue.when(
              data: (followedUsers) => ImportTwitchFollowsList(followedUsers: followedUsers),
              loading: () => ListView.builder(
                itemCount: 8,
                itemBuilder: (_, __) => const ImportTwitchFollowsListTileSkeleton(),
              ),
              error: (error, stack) => Center(child: Text("Error: $error")),
            ),
          ),
        ],
      ),
    );
  }
}

@riverpod
Future<List<TwitchUser>> _helixFollowedUsers(_HelixFollowedUsersRef ref) async {
  final followRepository = ref.watch(followRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  // Get the current user's Twitch ID
  final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
  if (currentUserId == null) return [];

  final follows = await followRepository.fetchUserTwitchFollows(currentUserId);
  final link = ref.keepAlive();
  // start a 30 second timer
  final timer = Timer(const Duration(minutes: 1), () {
    // dispose on timeout
    link.close();
  });

  ref.onDispose(() => timer.cancel());
  return userRepository.retrieveUsers(follows.map((follow) => follow.toId).toList());
}
