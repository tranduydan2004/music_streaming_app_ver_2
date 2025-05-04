import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ASongShareLinkScreen extends StatelessWidget {
  final String? title;
  final String? artist;
  final String? shareUrl;

  const ASongShareLinkScreen({
    super.key,
    this.title,
    this.artist,
    this.shareUrl,
  });

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy tham số từ arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final songTitle = arguments?['title'] ?? title ?? 'Unknown Title';
    final songArtist = arguments?['artist'] ?? artist ?? 'Unknown Artist';
    final songShareUrl = arguments?['shareUrl'] ?? shareUrl ?? 'https://example.com';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFAFEEEE), // Màu gradient trên
              Color(0xFF920A92), // Màu gradient dưới
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // TopBar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Quay lại ASongScreen
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Chia sẻ liên kết',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),

              // Thông tin bài hát
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    children: [
                      Image.network(
                        'https://picsum.photos/150?random=1', // Thay bằng URL ảnh bìa bài hát
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        songTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        songArtist,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ô nhập tin nhắn
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Leave a message...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Chia sẻ trực tiếp
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Share directly',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chat, color: Colors.green, size: 40),
                            onPressed: () => _launchUrl('https://weixin.qq.com'), // WeChat
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble, color: Colors.green, size: 40),
                            onPressed: () => _launchUrl('https://whatsapp.com'), // WhatsApp
                          ),
                          IconButton(
                            icon: const Icon(Icons.message, color: Colors.blue, size: 40),
                            onPressed: () => _launchUrl('https://messenger.com'), // Messenger
                          ),
                          IconButton(
                            icon: const Icon(Icons.alternate_email, color: Colors.blue, size: 40),
                            onPressed: () => _launchUrl('https://twitter.com'), // Twitter
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Chia sẻ qua ứng dụng khác
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Share via other apps',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.music_note, color: Colors.red, size: 40),
                            onPressed: () => _launchUrl(songShareUrl), // App 1
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_circle, color: Colors.red, size: 40),
                            onPressed: () => _launchUrl(songShareUrl), // App 2
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.red, size: 40),
                            onPressed: () => _launchUrl(songShareUrl), // App 3
                          ),
                          IconButton(
                            icon: const Icon(Icons.music_note, color: Colors.green, size: 40),
                            onPressed: () => _launchUrl(songShareUrl), // App 4
                          ),
                          IconButton(
                            icon: const Icon(Icons.music_note, color: Colors.yellow, size: 40),
                            onPressed: () => _launchUrl(songShareUrl), // App 5
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Thêm padding động
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}