import 'package:flutter/material.dart';
import 'package:hibi_track/ui/components/airing.dart';
import 'package:hibi_track/ui/pages/anime_detail_page.dart';

class MainPages extends StatefulWidget {
  const MainPages({super.key});

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Anime',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const Card(
                      color: Color.fromARGB(255, 139, 218, 255),
                      child: Center(child: Text('Anime Schedule')),
                    ),
                    const Card(
                      color: Color.fromARGB(255, 200, 230, 166),
                      child: Center(child: Text('Top Anime')),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AnimeDetailPage();
                        }));
                      },
                      child: const Card(
                        color: Color.fromARGB(255, 247, 164, 192),
                        child: Center(child: Text('Random Anime')),
                      ),
                    ),
                    const Card(
                      color: Color.fromARGB(255, 223, 166, 233),
                      child: Center(child: Text('Upcoming Season')),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Currently Airing',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Expanded(
                  child: Airing(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
