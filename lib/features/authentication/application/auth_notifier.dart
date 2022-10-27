import "dart:async";

import "package:amaterasu/features/authentication/data/auth_repository.dart";
import "package:amaterasu/features/authentication/domain/twitch_account.dart";
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_notifier.g.dart";

/// Implementation of [AsyncNotifier] that manages the authentication state
/// of the application.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  final Logger _log = Logger("AuthNotifier");

  /// Initializes the notifier with the current [TwitchAccount] if it exists.
  ///
  /// If the user is signed in,start a validation timer that checks if the
  /// token is valid every hour.
  ///
  /// See https://dev.twitch.tv/docs/authentication/validate-tokens for more
  /// information.
  @override
  Future<TwitchAccount?> build() async {
    _log.info("Initializing the auth state.");
    ref.listenSelf((_, current) {
      final account = current.valueOrNull;
      Timer? validationTimer;
      if (account != null) {
        _log.info("Authenticated as ${account.username} (${account.id}). Starting validation timer.");
        validationTimer = Timer.periodic(
          const Duration(hours: 1),
          (timer) async {
            final account = await ref.watch(authRepositoryProvider).retrieveTwitchAccount();
            // If the token is invalid, it will be silently removed from the storage so
            // we can just stop the timer and update the state.
            if (account == null) {
              timer.cancel();
              state = const AsyncData(null);
            }
          },
        );
      } else {
        if (current is AsyncData) {
          _log.info("The user is not authenticated.");
          validationTimer?.cancel();
          validationTimer = null;
        }

        if (current is AsyncError) {
          _log.warning("An error occurred while updating the auth state.", current.error, current.stackTrace);
        }
      }

      ref.onDispose(() => validationTimer?.cancel());
    });

    return ref.watch(authRepositoryProvider).retrieveTwitchAccount();
  }

  /// Signs in the user with the given [accessToken].
  ///
  /// The [accessToken] is stored in the secure storage and will be used to
  /// authenticate requests to the Twitch API.
  Future<void> login(final String accessToken) async {
    _log.info("Logging in with access token.");
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final account = await ref.watch(authRepositoryProvider).addTwitchAccount(accessToken);
      return account;
    });
  }

  /// Signs the user out of the application.
  ///
  /// This will remove the user's access token from the storage and revoke it.
  Future<void> logout() async {
    _log.info("Removing the authenticated account and logging out.");
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.watch(authRepositoryProvider).deleteTwitchAccount();
      return null;
    });
  }

  bool get isLoading => state.isLoading;

  bool get isAuthenticated => state.valueOrNull != null;
}
