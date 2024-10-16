import 'package:flutter/material.dart';
import 'package:hibi_track/model/anime_model.dart';
import 'package:hibi_track/services/anime_service.dart';
import 'package:hibi_track/ui/components/anime_detail.dart';

class AnimeDetailPage extends StatefulWidget {
  final int malId;

  const AnimeDetailPage({super.key, required this.malId});

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  AnimeModel? animeDetail;

  @override
  void initState() {
    super.initState();
    fetchDetailAnime(widget.malId);
  }

  Future<void> fetchDetailAnime(int malId) async {
    try {
      AnimeResponse response = await fetchAnimeById(malId);
      if (!mounted) return;
      setState(() {
        animeDetail = response.data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch anime details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 164, 192),
        title: const Text('Anime Details'),
      ),
      body: animeDetail != null
          ? AnimeDetail(animeDetail: animeDetail!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
