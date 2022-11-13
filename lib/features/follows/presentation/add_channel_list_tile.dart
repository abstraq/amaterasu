import "package:amaterasu/features/follows/application/local_follows_notifier.dart";
import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:amaterasu/features/users/presentation/twitch_user_circle_avatar.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "add_channel_list_tile.g.dart";

class AddChannelListTile extends ConsumerWidget {
  final TwitchUser broadcaster;

  const AddChannelListTile({super.key, required this.broadcaster});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: TwitchUserCircleAvatar(user: broadcaster, size: 42),
      title: Text(broadcaster.displayName),
      subtitle: const Text("Following on Twitch"),
      trailing: _AddChannelButton(broadcasterId: broadcaster.id),
    );
  }
}

class _AddChannelButton extends ConsumerWidget {
  final String broadcasterId;
  const _AddChannelButton({required this.broadcasterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowedValue = ref.watch(_broadcasterIsFollowedByCurrentUserProvider(broadcasterId));

    final buttonIcon = isFollowedValue.maybeWhen(
      data: (isFollowed) => isFollowed ? Icons.check : Icons.add,
      orElse: () => Icons.add,
    );

    final buttonText = isFollowedValue.maybeWhen(
      data: (isFollowed) => isFollowed ? "Added" : "Add",
      orElse: () => "Add",
    );

    final canPress = isFollowedValue.maybeWhen(
      data: (isFollowed) => !isFollowed,
      orElse: () => false,
    );

    return ElevatedButton.icon(
        onPressed:
            canPress ? () async => ref.read(localFollowsNotifierProvider.notifier).addFollow(broadcasterId) : null,
        icon: Icon(buttonIcon),
        label: Text(buttonText),
        style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(125, 40))));
  }
}

@riverpod
Future<bool> _broadcasterIsFollowedByCurrentUser(_BroadcasterIsFollowedByCurrentUserRef ref, String broadcasterId) {
  return ref.watch(localFollowsNotifierProvider.selectAsync((data) => data.containsKey(broadcasterId)));
}
