// lib/screens/all_songs_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:music_streaming_app/core/api.dart';
import 'a_song_screen.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  late Future<List<Music>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = _fetchSongs();
  }

  Future<List<Music>> _fetchSongs() async {
    final resp = await Api.client.getAuth('/music/list');
    final List<dynamic> data = json.decode(resp.body);
    return data.map((e) => Music.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tất cả bài hát')),
      body: FutureBuilder<List<Music>>(
        future: _songsFuture,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Lỗi: ${snap.error}'));
          }
          final songs = snap.data!;
          if (songs.isEmpty) {
            return const Center(child: Text('Chưa có bài nào'));
          }
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (ctx, i) {
              final m = songs[i];
              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(m.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ASongScreen(songId: m.id, title: m.name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Đơn giản hoá model Music
class Music {
  final int id;
  final String name;
  final String url;

  Music({required this.id, required this.name, required this.url});

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
