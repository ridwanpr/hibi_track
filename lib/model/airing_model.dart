class AiringModel {
  final int malId;
  final String url;
  final String title;
  final String titleEnglish;
  final String titleJapanese;
  final String imageUrl;
  final String trailerUrl;
  final String synopsis;
  final int episodes;
  final String type;
  final String status;
  final bool airing;
  final double score;
  final String airingFrom;
  final String duration;
  final String rating;

  AiringModel({
    required this.malId,
    required this.url,
    required this.title,
    required this.titleEnglish,
    required this.titleJapanese,
    required this.imageUrl,
    required this.trailerUrl,
    required this.synopsis,
    required this.episodes,
    required this.type,
    required this.status,
    required this.airing,
    required this.score,
    required this.airingFrom,
    required this.duration,
    required this.rating,
  });

  factory AiringModel.fromJson(Map<String, dynamic> json) {
    return AiringModel(
      malId: json['mal_id'],
      url: json['url'],
      title: json['title'],
      titleEnglish: json['title_english'] ?? '',
      titleJapanese: json['title_japanese'] ?? '',
      imageUrl: json['images']['jpg']['image_url'],
      trailerUrl: json['trailer']?['url'] ?? '',
      synopsis: json['synopsis'] ?? '',
      episodes: json['episodes'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      airing: json['airing'] ?? false,
      score: (json['score'] != null) ? json['score'].toDouble() : 0.0,
      airingFrom: json['aired']['string'] ?? '',
      duration: json['duration'] ?? '',
      rating: json['rating'] ?? '',
    );
  }
}

class AiringResponse {
  final List<AiringModel> data;

  AiringResponse({
    required this.data,
  });

  factory AiringResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<AiringModel> animeList = list.map((i) => AiringModel.fromJson(i)).toList();

    return AiringResponse(
      data: animeList,
    );
  }
}
