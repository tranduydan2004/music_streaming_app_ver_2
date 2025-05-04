import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:cached_network_image/cached_network_image.dart'; // Import cached_network_image
import 'audio_app_detail_screen.dart'; // Import màn hình chi tiết audio app

class ByResourcesScreen extends StatelessWidget {
  const ByResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách audio app
    final List<Map<String, dynamic>> audioApps = [
      {
        'name': 'Spotify',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/1/19/Spotify_logo_without_text.svg',
        'isSvg': true, // SVG
      },
      {
        'name': 'Apple Music',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/5/59/Apple_Music_Icon.svg',
        'isSvg': true, // SVG
      },
      {
        'name': 'YouTube',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/6/6a/Youtube_Music_icon.svg',
        'isSvg': true, // SVG
      },
      {
        'name': 'SoundCloud',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Antu_soundcloud.svg',
        'isSvg': true, // SVG
      },
    ];

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
                          Navigator.pop(context); // Quay lại LibraryScreen
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'By Resources',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Để cân đối với nút Back
                    ],
                  ),
                ),
              ),

              // Danh sách audio app
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final app = audioApps[index];
                    return _buildAudioAppItem(
                      context,
                      app['name'],
                      app['logo'],
                      app['isSvg'],
                    );
                  },
                  childCount: audioApps.length,
                ),
              ),

              // Thêm padding động để tránh tràn pixel
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
      // BottomBar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF60135E),
        selectedItemColor: Color(0xFFAFEEEE),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Chọn tab Library
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/browse');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/setting');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }

  // Widget cho mỗi audio app
  Widget _buildAudioAppItem(BuildContext context, String name, String logoUrl, bool isSvg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          // Điều hướng đến màn hình chi tiết audio app
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioAppDetailScreen(appName: name),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: isSvg
                      ? SvgPicture.network(
                          logoUrl,
                          fit: BoxFit.cover,
                          placeholderBuilder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          semanticsLabel: '$name logo',
                        )
                      : CachedNetworkImage(
                          imageUrl: logoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) {
                            print('Error loading image for $name: $error');
                            return const Center(
                              child: Icon(
                                Icons.music_note,
                                color: Colors.white70,
                                size: 20,
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}