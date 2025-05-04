import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'a_song_screen.dart';
import 'music_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Unknown User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFAFEEEE), Color(0xFF920A92)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lời chào
                      Text(
                        'Hi ${_username ?? 'Unknown User'}.',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'How\'s it going?',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 30),

                      // Tìm kiếm bài hát
                      const Text(
                        'Search for songs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4081),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SearchBar(),

                      const SizedBox(height: 30),

                      // Your top playlists
                      const Text(
                        'Your top playlists',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4081),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPlaylistList(),

                      const SizedBox(height: 30),

                      // Your recent artists
                      const Text(
                        'Your recent artists',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4081),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildArtistList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF920A92),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFAFEEEE)),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Trang chủ',
              route: '/home',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person,
              title: 'Hồ sơ',
              route: '/profile',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.qr_code_scanner,
              title: 'Quét mã QR',
              route: '/scan_qr',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              title: 'Cài đặt',
              route: '/setting',
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
    );
  }

  // Drawer item
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required String route}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  // TopBar
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          const Text(
            'Home',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/support'); // Điều hướng đến màn hình Support
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile'); // Điều hướng đến màn hình Profile
                },
                child: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Playlist list
  Widget _buildPlaylistList() {
    final playlists = [
      {'title': 'Cooking chillies', 'imageUrl': 'https://picsum.photos/150?random=1'},
      {'title': 'Workout monster', 'imageUrl': 'https://picsum.photos/150?random=2'},
    ];

    return Column(
      children: playlists.map((playlist) {
        return ListTile(
          leading: Image.network(playlist['imageUrl']!, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(playlist['title']!, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.play_arrow, color: Colors.white),
          onTap: () {
            // Điều hướng đến màn hình playlist
          },
        );
      }).toList(),
    );
  }

  // Artist list
  Widget _buildArtistList() {
    final artists = [
      {'name': 'Olivia R...', 'imageUrl': 'https://picsum.photos/150?random=10'},
      {'name': 'Post Ma...', 'imageUrl': 'https://picsum.photos/150?random=11'},
    ];

    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: artists.map((artist) {
          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(artist['imageUrl']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  artist['name']!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // BottomNavigationBar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF60135E),
      selectedItemColor: const Color(0xFFAFEEEE),
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) Navigator.pushNamed(context, '/browse');
        if (index == 2) Navigator.pushNamed(context, '/library');
        if (index == 3) Navigator.pushNamed(context, '/profile');
        if (index == 4) Navigator.pushNamed(context, '/setting');
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.library_music), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
      ],
    );
  }
}

// Search bar widget
class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

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

  void _startVoiceSearch() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _searchController.text = result.recognizedWords;
              _isListening = false;
            });
            if (_searchController.text.isNotEmpty) {
              _searchMusic(); // Tự động tìm kiếm sau khi nhận diện giọng nói
            }
          },
          localeId: 'vi_VN', // Sử dụng tiếng Việt
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
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
                onSubmitted: (_) => _searchMusic(),
              ),
            ),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic_off : Icons.mic,
                color: Colors.white,
              ),
              onPressed: _startVoiceSearch,
            ),
          ],
        ),
        if (_isListening)
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Listening...',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.mic, size: 80, color: Colors.red),
              ],
            ),
          ),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          ),
        if (_searchResults.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final song = _searchResults[index];
              return ListTile(
                leading: const Icon(Icons.music_note, color: Colors.white),
                title: Text(song['name'], style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ASongScreen(songId: song['id']),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}