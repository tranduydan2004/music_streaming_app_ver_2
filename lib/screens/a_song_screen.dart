import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_streaming_app/core/api.dart';

class ASongScreen extends StatefulWidget {
  final int songId;
  final String? title; // Cho phép null để tránh lỗi

  const ASongScreen({
    super.key,
    required this.songId,
    this.title,
  });

  @override
  State<ASongScreen> createState() => _ASongScreenState();
}

class _ASongScreenState extends State<ASongScreen> {
  late AudioPlayer _player;
  String? _url;
  bool _loading = true;
  bool _playing = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadSong();
  }

  Future<void> _loadSong() async {
    try {
      final resp = await Api.client.getAuth('/music/play/${widget.songId}');
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        _url = body['url'] as String?;
        if (_url != null && _url!.isNotEmpty) {
          await _player.setUrl(_url!);
          _duration = _player.duration ?? Duration.zero;

          // Lắng nghe trạng thái trình phát
          _player.positionStream.listen((pos) {
            setState(() => _position = pos);
          });
          _player.playerStateStream.listen((state) {
            setState(() => _playing = state.playing);
          });
        } else {
          throw Exception('URL bài hát không hợp lệ.');
        }
      } else {
        throw Exception('Không thể tải bài hát. Mã lỗi: ${resp.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải bài hát: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Bài hát'), // Hiển thị tiêu đề mặc định nếu title null
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Thanh trượt thời gian
                Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (v) {
                    _player.seek(Duration(seconds: v.toInt()));
                  },
                ),
                // Các nút điều khiển
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        final newPos = _position - const Duration(seconds: 10);
                        _player.seek(newPos > Duration.zero ? newPos : Duration.zero);
                      },
                    ),
                    IconButton(
                      icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
                      iconSize: 40,
                      onPressed: () {
                        _playing ? _player.pause() : _player.play();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        final newPos = _position + const Duration(seconds: 10);
                        _player.seek(newPos < _duration ? newPos : _duration);
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}