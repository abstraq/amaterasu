import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";

class ImportTwitchFollowsListTileSkeleton extends StatelessWidget {
  const ImportTwitchFollowsListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
