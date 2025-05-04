import 'package:flutter/material.dart';
import 'music_service.dart';
import 'a_song_screen.dart';
import 'playlist_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  // Dữ liệu giả lập cho các mục cũ
  final List<Map<String, String>> _popularGenres = [
    {'title': 'Pop', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'Hip Hop', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'Classical', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'Jazz', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'EDM', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'Blue', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'R&B', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'Indie', 'imageUrl': 'https://via.placeholder.com/150'},
  ];

  final List<Map<String, String>> _dailyRecommendations = [
    {'title': 'Workout Monster', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'Productivity 101', 'imageUrl': 'https://via.placeholder.com/150'},
  ];

  final List<Map<String, String>> _newReleases = [
    {'title': 'This is Ed Sheeran', 'imageUrl': 'https://via.placeholder.com/150'},
    {'title': 'Speak Now', 'imageUrl': 'https://via.placeholder.com/150'},
  ];

  Future<void> _searchMusic() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a keyword to search')),
      );
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await MusicService.searchMusic(keyword);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching music: $e')),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF920A92),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFAFEEEE),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Trang chủ', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Hồ sơ', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner, color: Colors.white),
                title: const Text('Quét mã QR', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/scan_qr');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text('Cài đặt', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/setting');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã đăng xuất')),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/signup',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFAFEEEE),
              Color(0xFF920A92),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // TopBar với thanh tìm kiếm
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for songs...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _searchMusic,
                    ),
                  ],
                ),
              ),

              // Nội dung chính
              Expanded(
                child: _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final song = _searchResults[index];
                              return ListTile(
                                leading: const Icon(Icons.music_note, color: Colors.white),
                                title: Text(
                                  song['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ASongScreen(
                                        songId: song['id'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : ListView(
                            children: [
                              // Popular genres
                              _buildSectionTitle('Popular Genres'),
                              _buildGenreGrid(),

                              // Daily recommendations
                              _buildSectionTitle('Daily Recommendations'),
                              _buildPlaylistList(_dailyRecommendations),

                              // New releases
                              _buildSectionTitle('New Releases'),
                              _buildPlaylistList(_newReleases),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF60135E),
        selectedItemColor: const Color(0xFFAFEEEE),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/library');
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

  // Widget tiêu đề cho mỗi phần
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget lưới thể loại nhạc
  Widget _buildGenreGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _popularGenres.length,
      itemBuilder: (context, index) {
        final genre = _popularGenres[index];
        return _buildGenreCard(genre['title']!, genre['imageUrl']!);
      },
    );
  }

  // Widget thẻ thể loại
  Widget _buildGenreCard(String title, String imageUrl) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, height: 80, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget danh sách playlist
  Widget _buildPlaylistList(List<Map<String, String>> playlists) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return ListTile(
          leading: Image.network(playlist['imageUrl']!, height: 50, fit: BoxFit.cover),
          title: Text(
            playlist['title']!,
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistScreen(
                  playlistName: playlist['title']!,
                  songs: [], // Truyền danh sách bài hát nếu có
                ),
              ),
            );
          },
        );
      },
    );
  }
}