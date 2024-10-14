import 'package:flutter/material.dart';
import 'package:hibi_track/model/airing_model.dart';
import 'package:hibi_track/services/anime_service.dart';

class Airing extends StatefulWidget {
  const Airing({super.key});

  @override
  State<Airing> createState() => _AiringState();
}

class _AiringState extends State<Airing> {
  List<AiringModel> currentSeasonAnime = [];

  @override
  void initState() {
    super.initState();
    fetchAnimes();
  }

  Future<void> fetchAnimes() async {
    try {
      AiringResponse response = await fetchCurrentSeasonAnimes(1);
      setState(() {
        currentSeasonAnime = response.data;
      });
    } catch (e) {
      throw Exception('Failed to fetch current season data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: currentSeasonAnime.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    currentSeasonAnime[index].imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      currentSeasonAnime[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
