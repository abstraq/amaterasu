import "package:amaterasu/features/follows/presentation/import_twitch_follows_list_tile.dart";
import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:flutter/material.dart";

class ImportTwitchFollowsList extends StatelessWidget {
  final List<TwitchUser> followedUsers;

  const ImportTwitchFollowsList({super.key, required this.followedUsers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: followedUsers.length,
      itemBuilder: (context, index) => ImportTwitchFollowsListTile(broadcaster: followedUsers[index]),
    );
  }
}
