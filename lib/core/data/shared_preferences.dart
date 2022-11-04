import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "shared_preferences.g.dart";

/// Provider for shared preferences.
///
/// This implementation is overriden in the ProviderScope.
@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) => throw UnimplementedError();
