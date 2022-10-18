import "dart:async";

import "package:amaterasu/features/authentication/data/auth_repository.dart";
import "package:amaterasu/features/authentication/domain/credentials.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_controller.g.dart";

@riverpod
class AuthController extends _$AuthController {
  static const Duration _validationRefreshInterval = Duration(hours: 1);

  late AuthRepository _authRepository;

  Timer? _validationTimer;

  @override
  Future<Credentials?> build() async {
    _authRepository = ref.watch(authRepositoryProvider);

    final credentials = await _authRepository.retrieveCredentials();
    if (credentials != null && credentials is UserCredentials) _startValidationTimer();
    return credentials;
  }

  Future<void> connectTwitchAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final credentials = await _authRepository.addCredentials();
      _startValidationTimer();
      return credentials;
    });
  }

  Future<void> removeTwitchAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.deleteCredentials();
      _stopValidationTimer();
      return null;
    });
  }

  void _stopValidationTimer() {
    _validationTimer?.cancel();
    _validationTimer = null;
  }

  void _startValidationTimer() {
    _validationTimer?.cancel();
    _validationTimer = Timer.periodic(_validationRefreshInterval, (timer) async {
      try {
        final isValid = await _authRepository.isCredentialsValid();
        if (!isValid) {
          await _authRepository.deleteCredentials(revoke: false);
          _stopValidationTimer();
        }
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    });
  }

  bool get isAuthenticated => state.valueOrNull != null;
  bool get isLoading => state.isLoading;
}
