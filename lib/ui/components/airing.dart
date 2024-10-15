import 'package:flutter/material.dart';
import 'package:hibi_track/model/airing_model.dart';
import 'package:hibi_track/services/anime_service.dart';
import 'package:hibi_track/ui/pages/anime_detail_page.dart';

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
      if (!mounted) return;
      setState(() {
        currentSeasonAnime = response.data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch current season data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double itemWidth = 160;
        final int crossAxisCount = (constraints.maxWidth / itemWidth).floor();

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount > 2 ? crossAxisCount : 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemCount: currentSeasonAnime.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AnimeDetailPage(malId: currentSeasonAnime[index].malId),
                  ),
                );
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                        child: Image.network(
                          currentSeasonAnime[index].imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            currentSeasonAnime[index].title,
                            maxLines: 2,
                            textAlign: TextAlign.center,
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
              ),
            );
          },
        );
      },
    );
  }
}
