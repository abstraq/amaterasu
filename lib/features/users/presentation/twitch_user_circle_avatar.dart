import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:octo_image/octo_image.dart";
import "package:skeletons/skeletons.dart";

class TwitchUserCircleAvatar extends StatelessWidget {
  final TwitchUser user;
  final double size;

  const TwitchUserCircleAvatar({super.key, required this.user, required this.size});

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      width: size,
      fadeInDuration: const Duration(milliseconds: 5),
      fit: BoxFit.cover,
      image: CachedNetworkImageProvider(user.profileImageUrl),
      imageBuilder: OctoImageTransformer.circleAvatar(),
      placeholderBuilder: (_) => SkeletonAvatar(style: SkeletonAvatarStyle(width: size, shape: BoxShape.circle)),
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}
