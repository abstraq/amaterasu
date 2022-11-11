import "package:amaterasu/features/accounts/data/account_repository.dart";
import "package:amaterasu/features/follows/data/follow_repository.dart";
import "package:amaterasu/features/users/data/user_repository.dart";
import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:octo_image/octo_image.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "add_channel_list.g.dart";

class AddChannelList extends ConsumerWidget {
  const AddChannelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_followedUsersProvider).when(
          data: (users) {
            final followedUsers = [...users]..sort((a, b) => a.displayName.compareTo(b.displayName));
            return ListView.builder(
              itemCount: followedUsers.length,
              itemBuilder: (context, index) {
                final user = followedUsers[index];
                return ListTile(
                  leading: OctoImage.fromSet(
                    width: 42,
                    fadeInDuration: const Duration(milliseconds: 50),
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(user.profileImageUrl),
                    octoSet: OctoSet.circleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      text: Text(user.login.characters.first.toUpperCase()),
                    ),
                  ),
                  title: Text(user.displayName),
                  onTap: () => context.go("/channels/${user.id}"),
                  trailing: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.vibrate();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  ),
                );
              },
            );
          },
          error: (_, __) => Center(child: Text(_.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}

@riverpod
Future<List<TwitchUser>> _followedUsers(_FollowedUsersRef ref) async {
  final followRepository = ref.watch(followRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  // Get the current user's Twitch ID
  final currentUserId = await ref.watch(accountRepositoryProvider).retrieveCurrentAccountId();
  if (currentUserId == null) return [];

  final follows = await followRepository.fetchUserTwitchFollows(currentUserId);
  return userRepository.retrieveUsers(follows.map((follow) => follow.toId).toList());
}
