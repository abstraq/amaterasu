import "dart:convert";

import "package:amaterasu/core/data/helix_http_client.dart";
import "package:amaterasu/core/exceptions/http_exception.dart";
import "package:amaterasu/features/users/domain/helix_get_users_response.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "helix_user_data_source.g.dart";

class HelixUserDataSource {
  final HelixHttpClient _helix;

  HelixUserDataSource(this._helix);

  Future<HelixGetUsersResponse> fetchUsers(List<String> userIds) async {
    final url = Uri.https("api.twitch.tv", "/helix/users", {"id": userIds});
    final response = await _helix.get(url);

    if (response.statusCode != 200) {
      throw HttpException(uri: response.request?.url, statusCode: response.statusCode, body: response.body);
    }

    return HelixGetUsersResponse.fromJson(json.decode(response.body));
  }
}

@riverpod
HelixUserDataSource helixUserDataSource(HelixUserDataSourceRef ref) {
  final client = ref.watch(helixHttpClientProvider);
  return HelixUserDataSource(client);
}
