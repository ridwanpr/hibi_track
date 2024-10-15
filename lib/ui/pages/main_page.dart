import 'package:flutter/material.dart';
import 'package:hibi_track/ui/components/airing.dart';
import 'package:hibi_track/ui/pages/random_detail_page.dart';
import 'package:hibi_track/ui/pages/schedule_page.dart';
import 'package:hibi_track/ui/pages/top_anime_page.dart';

class MainPages extends StatelessWidget {
  const MainPages({super.key});

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
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SchedulePage()),
                            ),
                            child: const Card(
                              color: Color.fromARGB(255, 139, 218, 255),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: Text('Anime Schedule')),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TopAnimePage())),
                            child: const Card(
                              color: Color.fromARGB(255, 200, 230, 166),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text('Top Anime'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RandomDetailPage()),
                      ),
                      child: const Card(
                        color: Color.fromARGB(255, 247, 164, 192),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('Discover Random Anime')),
                        ),
                      ),
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
