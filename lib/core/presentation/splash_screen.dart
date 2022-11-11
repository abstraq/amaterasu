import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Screen that is displayed while the app is loading.
///
/// Displays a loading indicator and optional information
/// about the current loading state.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
