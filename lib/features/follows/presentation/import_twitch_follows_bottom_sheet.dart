import "dart:async";

import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/follows/application/local_follows_notifier.dart";
import "package:amaterasu/features/follows/data/follow_repository.dart";
import "package:amaterasu/features/follows/domain/follow.dart";
import "package:amaterasu/features/follows/presentation/import_twitch_follows_list.dart";
import "package:amaterasu/features/follows/presentation/import_twitch_follows_list_tile_skeleton.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "import_twitch_follows_bottom_sheet.g.dart";

class ImportTwitchFollowsBottomSheet extends ConsumerWidget {
  const ImportTwitchFollowsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followsValue = ref.watch(_currentUserTwitchFollowsProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: followsValue.valueOrNull != null && followsValue.valueOrNull!.isNotEmpty
                  ? () async => ref
                      .read(localFollowsNotifierProvider.notifier)
                      .addFollows(followsValue.valueOrNull!.values.toList())
                  : null,
              child: const Text("Import All")),
          Expanded(
            child: followsValue.when(
              data: (follows) => ImportTwitchFollowsList(follows: follows.values.toList()),
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
Future<Map<String, Follow>> _currentUserTwitchFollows(_CurrentUserTwitchFollowsRef ref) async {
  // Get the current user's Twitch ID
  final currentUserId = ref.watch(authNotifierProvider).valueOrNull?.userId;
  if (currentUserId == null) return {};

  final follows = await ref.watch(twitchFollowsProvider(currentUserId).future);
  return follows;
}
