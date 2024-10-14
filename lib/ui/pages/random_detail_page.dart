import 'package:flutter/material.dart';
import 'package:hibi_track/model/anime_model.dart';
import 'package:hibi_track/services/anime_service.dart';
import 'package:hibi_track/ui/components/anime_detail.dart';

class RandomDetailPage extends StatefulWidget {
  const RandomDetailPage({super.key});

  @override
  State<RandomDetailPage> createState() => _RandomDetailPageState();
}

class _RandomDetailPageState extends State<RandomDetailPage> {
  AnimeModel? animeDetail;

  @override
  void initState() {
    super.initState();
    fetchDetailRandomAnime();
  }

  Future<void> fetchDetailRandomAnime() async {
    try {
      AnimeResponse response = await fetchRandomAnime();
      if (!mounted) return;
      setState(() {
        animeDetail = response.data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch anime details')),
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
