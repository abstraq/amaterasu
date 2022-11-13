import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/follows/data/follow_repository.dart";
import "package:amaterasu/features/follows/presentation/add_channel_list_tile.dart";
import "package:amaterasu/features/users/data/user_repository.dart";
import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:skeletons/skeletons.dart";

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
              itemBuilder: (context, index) => AddChannelListTile(broadcaster: followedUsers[index]),
            );
          },
          loading: () => ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) => ListTile(
              leading: const SkeletonAvatar(style: SkeletonAvatarStyle(width: 42, shape: BoxShape.circle)),
              title: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  minLength: 50,
                  maxLength: 125,
                  randomLength: true,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              subtitle: SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: 125,
                  randomLength: false,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              trailing: SkeletonItem(
                child: ElevatedButton.icon(
                    onPressed: null,
                    style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(125, 40))),
                    icon: const Icon(Icons.add),
                    label: const Text("Add")),
              ),
            ),
          ),
          error: (_, __) => Center(child: Text(_.toString())),
        );
  }
}

@riverpod
Future<List<TwitchUser>> _followedUsers(_FollowedUsersRef ref) async {
  final followRepository = ref.watch(followRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  // Get the current user's Twitch ID
  final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
  if (currentUserId == null) return [];

  final follows = await followRepository.fetchUserTwitchFollows(currentUserId);
  return userRepository.retrieveUsers(follows.map((follow) => follow.toId).toList());
}
