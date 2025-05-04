import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  final String playlistName;
  final List<Map<String, String>> songs;

  const PlaylistScreen({
    super.key,
    required this.playlistName,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
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
                          Navigator.pop(context); // Quay lại thư viện
                        },
                      ),
                      Expanded(
                        child: Text(
                          playlistName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (songs.isNotEmpty) {
                            // Phát bài hát đầu tiên
                            print('Playing: ${songs[0]['title']} by ${songs[0]['artist']}');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Danh sách bài hát
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = songs[index];
                    return _buildSongItem(
                      song['title']!,
                      song['artist']!,
                      song['platform']!,
                    );
                  },
                  childCount: songs.length,
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
        currentIndex: 2, // Chọn tab Playlist
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

  // Widget cho mỗi bài hát
  Widget _buildSongItem(String title, String artist, String platform) {
    IconData platformIcon;
    Color platformColor;

    // Xác định icon và màu sắc dựa trên nền tảng
    switch (platform.toLowerCase()) {
      case 'spotify':
        platformIcon = Icons.music_note;
        platformColor = Colors.green;
        break;
      case 'youtube':
        platformIcon = Icons.play_circle_filled;
        platformColor = Colors.red;
        break;
      default:
        platformIcon = Icons.music_note;
        platformColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              platformIcon,
              color: platformColor,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    artist,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white70,
              ),
              onSelected: (value) {
                _handlePopupMenuSelection(value, title);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'add_to_playlist',
                  child: Text('Add to Playlist'),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Text('Share'),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Xử lý các lựa chọn trong menu popup
  void _handlePopupMenuSelection(String value, String title) {
    switch (value) {
      case 'add_to_playlist':
        // Xử lý thêm bài hát vào playlist
        print('Added $title to playlist');
        break;
      case 'share':
        // Xử lý chia sẻ bài hát
        print('Shared $title');
        break;
      case 'remove':
        // Xử lý xóa bài hát khỏi playlist
        print('Removed $title from playlist');
        break;
      default:
        break;
    }
  }
}
