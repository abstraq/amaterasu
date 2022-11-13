import "package:amaterasu/features/follows/domain/follow.dart";
import "package:amaterasu/features/follows/presentation/import_twitch_follows_list_tile.dart";
import "package:flutter/material.dart";

class ImportTwitchFollowsList extends StatelessWidget {
  final List<Follow> follows;

  const ImportTwitchFollowsList({super.key, required this.follows});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: follows.length,
      itemBuilder: (context, index) => ImportTwitchFollowsListTile(follow: follows[index]),
    );
  }
}
