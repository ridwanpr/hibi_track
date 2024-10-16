import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hibi_track/ui/pages/anime_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:hibi_track/model/schedule_model.dart';
import 'package:hibi_track/services/anime_service.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<ScheduleModel> scheduleAnime = [];
  bool isLoading = true;
  String selectedDay = DateFormat('EEEE').format(DateTime.now()).toLowerCase();

  final List<String> daysForDropdown = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  final Map<int, String> countdowns = {};

  static const Map<String, int> daysOfWeek = {
    'monday': DateTime.monday,
    'tuesday': DateTime.tuesday,
    'wednesday': DateTime.wednesday,
    'thursday': DateTime.thursday,
    'friday': DateTime.friday,
    'saturday': DateTime.saturday,
    'sunday': DateTime.sunday,
  };

  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    fetchSchedule(selectedDay);
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchSchedule(String day) async {
    setState(() => isLoading = true);
    try {
      ScheduleResponse response = await fetchScheduleByDays(day);
      if (!mounted) return;

      setState(() {
        scheduleAnime = response.data;
        startCountdowns();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch schedule: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void startCountdowns() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        for (var anime in scheduleAnime) {
          DateTime now = DateTime.now();
          DateTime broadcastTime =
              getNextBroadcast(anime.broadcastDay, anime.broadcastTime ?? '-');
          if (broadcastTime.isBefore(now)) {
            broadcastTime = broadcastTime.add(const Duration(days: 7));
          }
          Duration difference = broadcastTime.difference(now);
          countdowns[anime.malId] = formatDuration(difference);
        }
      });
    });
  }

  DateTime getNextBroadcast(String day, String time) {
    int broadcastDay = daysOfWeek[day.toLowerCase()] ?? DateTime.now().weekday;

    var now = DateTime.now();
    DateTime broadcastDateTime;

    try {
      var parsedTime = DateFormat('HH:mm').parse(time);
      broadcastDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      debugPrint(
          'Error parsing time: $e,  datetime not valid.... data ignored.');
      return now;
    }
    var daysUntilNext = (broadcastDay - now.weekday + 7) % 7;

    if (daysUntilNext == 0 && broadcastDateTime.isBefore(now)) {
      daysUntilNext = 7;
    }

    return broadcastDateTime.add(Duration(days: daysUntilNext));
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours hours, $minutes minutes, $seconds seconds';
    } else if (minutes > 0) {
      return '$minutes minutes, $seconds seconds';
    } else {
      return '$seconds seconds';
    }
  }

  void onDaySelected(String day) {
    setState(() {
      selectedDay = day;
      countdowns.clear();
    });
    fetchSchedule(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 139, 218, 255),
        title: const Text('Anime Schedule'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedDay,
              items: daysForDropdown.map((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day[0].toUpperCase() + day.substring(1)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onDaySelected(newValue);
                }
              },
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: scheduleAnime.length,
                    itemBuilder: (context, index) {
                      final anime = scheduleAnime[index];
                      if (anime.broadcastTime!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AnimeDetailPage(
                                    malId: scheduleAnime[index].malId);
                              }));
                            },
                            child: Card(
                              elevation: 3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    height: 200,
                                    child: Image.network(
                                      anime.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.error),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            anime.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (anime.titleEnglish.isNotEmpty)
                                            Text(
                                              'English: ${anime.titleEnglish}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (anime.titleJapanese.isNotEmpty)
                                            Text(
                                              'Japanese: ${anime.titleJapanese}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Type: ${anime.type}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Episodes: ${anime.totalEpisodes}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Source: ${anime.source}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Broadcast: ${anime.broadcastString}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Next episode in: ${countdowns[anime.malId] ?? '-'}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
