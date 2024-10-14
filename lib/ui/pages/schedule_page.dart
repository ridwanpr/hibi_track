import 'package:flutter/material.dart';
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
  String selectedDay = 'monday';

  final List<String> days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  @override
  void initState() {
    super.initState();
    fetchSchedule(selectedDay);
  }

  Future<void> fetchSchedule(String day) async {
    setState(() {
      isLoading = true;
    });

    try {
      ScheduleResponse response = await fetchScheduleByDays(day);
      if (!mounted) return;
      setState(() {
        scheduleAnime = response.data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch schedule: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onDaySelected(String day) {
    setState(() {
      selectedDay = day;
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
              items: days.map((String day) {
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...scheduleAnime.map((anime) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 2,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 125,
                                    height: 180,
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
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            anime.titleEnglish,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            anime.titleJapanese,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Type: ${anime.type}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            'Episodes: ${anime.totalEpisodes}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            'Season: ${anime.season ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
