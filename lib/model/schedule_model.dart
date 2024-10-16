class ScheduleModel {
  final int malId;
  final String imageUrl;
  final String title;
  final String titleEnglish;
  final String titleJapanese;
  final String type;
  final int totalEpisodes;
  final String? season;
  final int year;
  final String source;
  final String broadcastDay;
  final String? broadcastTime;
  final String? broadcastTimezone;
  final String? broadcastString;

  ScheduleModel({
    required this.malId,
    required this.imageUrl,
    required this.title,
    required this.titleEnglish,
    required this.titleJapanese,
    required this.type,
    required this.totalEpisodes,
    this.season,
    required this.year,
    required this.source,
    required this.broadcastDay,
    required this.broadcastTime,
    required this.broadcastTimezone,
    required this.broadcastString,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      malId: json['mal_id'],
      imageUrl: json['images']['jpg']['image_url'] ?? '',
      title: json['title'] ?? '',
      titleEnglish: json['title_english'] ?? '',
      titleJapanese: json['title_japanese'] ?? '',
      type: json['type'] ?? '',
      totalEpisodes: json['episodes'] ?? 0,
      season: json['season'],
      year: json['year'] ?? 0,
      source: json['source'] ?? '',
      broadcastDay: json['broadcast']['day'] ?? '',
      broadcastTime: json['broadcast']['time'] ?? '',
      broadcastTimezone: json['broadcast']['timezone'] ?? '',
      broadcastString: json['broadcast']['string'] ?? '',
    );
  }
}

class ScheduleResponse {
  final List<ScheduleModel> data;

  ScheduleResponse({
    required this.data,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ScheduleModel> scheduleList =
        list.map((i) => ScheduleModel.fromJson(i)).toList();

    return ScheduleResponse(
      data: scheduleList,
    );
  }
}
