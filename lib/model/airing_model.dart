class AiringModel {
  final int malId;
  final String title;
  final String imageUrl;

  AiringModel({
    required this.malId,
    required this.title,
    required this.imageUrl,
  });

  factory AiringModel.fromJson(Map<String, dynamic> json) {
    return AiringModel(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
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
    List<AiringModel> animeList =
        list.map((i) => AiringModel.fromJson(i)).toList();

    return AiringResponse(
      data: animeList,
    );
  }
}
