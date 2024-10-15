import 'dart:convert';
import 'package:hibi_track/model/airing_model.dart';
import 'package:hibi_track/model/anime_model.dart';
import 'package:hibi_track/model/schedule_model.dart';
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

Future<AnimeResponse> fetchRandomAnime() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/random/anime'));

  if (response.statusCode == 200) {
    return AnimeResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load random anime');
  }
}

Future<AnimeResponse> fetchAnimeById(int malId) async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/anime/$malId'));

  if (response.statusCode == 200) {
    return AnimeResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load anime detail');
  }
}

Future<ScheduleResponse> fetchScheduleByDays(String day) async {
  final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/schedules?filter=$day&kids=false'));

  if (response.statusCode == 200) {
    return ScheduleResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load schedule');
  }
}

Future<AnimeListResponse> fetchTopAnime() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));

  if (response.statusCode == 200) {
    return AnimeListResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load schedule');
  }
}
