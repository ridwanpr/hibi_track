class AnimeModel {
  final int malId;
  final String url;
  final String title;
  final String titleEnglish;
  final String titleJapanese;
  final String imageUrl;
  final String synopsis;
  final int episodes;
  final String type;
  final double score;
  final List<String> genres;
  final String rating;

  AnimeModel({
    required this.malId,
    required this.url,
    required this.title,
    required this.titleEnglish,
    required this.titleJapanese,
    required this.imageUrl,
    required this.synopsis,
    required this.episodes,
    required this.type,
    required this.score,
    required this.rating,
    required this.genres,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      malId: json['mal_id'],
      url: json['url'],
      title: json['title'],
      titleEnglish: json['title_english'] ?? '',
      titleJapanese: json['title_japanese'] ?? '',
      imageUrl: json['images']['jpg']['image_url'],
      synopsis: json['synopsis'] ?? '',
      episodes: json['episodes'] ?? 0,
      type: json['type'] ?? '',
      score: (json['score'] != null) ? json['score'].toDouble() : 0.0,
      rating: json['rating'] ?? '',
      genres: List<String>.from(json['genres'].map((genre) => genre['name'])),
    );
  }
}

class AnimeResponse {
  final AnimeModel data;

  AnimeResponse({
    required this.data,
  });

  factory AnimeResponse.fromJson(Map<String, dynamic> json) {
    return AnimeResponse(
      data: AnimeModel.fromJson(json['data']),
    );
  }
}
