import 'package:flutter/material.dart';
import 'package:hibi_track/model/anime_model.dart';
import 'package:hibi_track/services/anime_service.dart';
import 'package:hibi_track/ui/pages/anime_detail_page.dart';

class TopAnimePage extends StatefulWidget {
  const TopAnimePage({super.key});

  @override
  State<TopAnimePage> createState() => _TopAnimePageState();
}

class _TopAnimePageState extends State<TopAnimePage> {
  List<AnimeModel> topAnime = [];

  @override
  void initState() {
    super.initState();
    fetchTopAnimes();
  }

  Future<void> fetchTopAnimes() async {
    try {
      AnimeListResponse response = await fetchTopAnime();
      if (!mounted) return;
      setState(() {
        topAnime = response.data;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 230, 166),
        title: const Text('Top Anime'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: topAnime.map((anime) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AnimeDetailPage(malId: anime.malId);
                      }));
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              (topAnime.indexOf(anime) + 1).toString(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(anime.imageUrl),
                          ),
                          Flexible(
                            child: Text(
                              anime.title,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
