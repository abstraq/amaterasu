import "dart:convert";

import "package:amaterasu/core/data/helix_http_client.dart";
import "package:amaterasu/core/exceptions/http_exception.dart";
import "package:amaterasu/features/follows/domain/helix_get_user_follows_response.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "helix_follows_data_source.g.dart";

class HelixFollowsDataSource {
  final HelixHttpClient _helix;

  HelixFollowsDataSource(this._helix);

  Future<HelixGetUserFollowsResponse> fetchUserFollows(String userId, {int first = 100, String? cursor}) async {
    final url = Uri.https("api.twitch.tv", "/helix/users/follows", {
      "from_id": userId,
      "first": "$first",
      if (cursor != null) "after": cursor,
    });
    final response = await _helix.get(url);

    if (response.statusCode != 200) {
      throw HttpException(uri: response.request?.url, statusCode: response.statusCode, body: response.body);
    }

    return HelixGetUserFollowsResponse.fromJson(json.decode(response.body));
  }
}

@riverpod
HelixFollowsDataSource helixFollowsDataSource(HelixFollowsDataSourceRef ref) {
  final client = ref.watch(helixHttpClientProvider);
  return HelixFollowsDataSource(client);
}
