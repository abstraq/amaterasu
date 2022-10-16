import "package:amaterasu/features/authentication/data/auth_repository.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_controller.g.dart";

@riverpod
class AuthController extends _$AuthController {
  late AuthRepository _authRepository;

  @override
  Future<String?> build() async {
    _authRepository = ref.watch(authRepositoryProvider);

    return _authRepository.retrieveCurrentAccessToken();
  }

  Future<void> login() async {
    state = await AsyncValue.guard(() async {
      await _authRepository.authorize();
      return _authRepository.retrieveCurrentAccessToken();
    });
  }

  Future<void> logout() async {
    state = await AsyncValue.guard(() async {
      await _authRepository.revoke();
      return null;
    });
  }

  bool get isAuthenticated => state.valueOrNull != null;
  bool get isLoading => state.isLoading;
}
