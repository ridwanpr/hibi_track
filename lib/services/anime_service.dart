import 'dart:convert';
import 'package:hibi_track/model/airing_model.dart';
import 'package:http/http.dart' as http;

Future<AiringResponse> fetchCurrentSeasonAnimes(int page) async {
  final response = await http
      .get(Uri.parse('https://api.jikan.moe/v4/seasons/now?page=$page'));

  if (response.statusCode == 200) {
    return AiringResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load current season animes');
  }
}
