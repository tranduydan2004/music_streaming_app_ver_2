import 'package:flutter/material.dart';
import 'playlist_screen.dart';

class AudioAppDetailScreen extends StatelessWidget {
  final String appName;

  const AudioAppDetailScreen({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả lập cho playlist và single songs
    final Map<String, Map<String, List<Map<String, dynamic>>>> appData = {
      'Spotify': {
        'playlists': [
          {
            'title': 'Cooking chillies',
            'image': 'https://picsum.photos/150?random=1',
            'songs': [
              {'title': 'Never Gonna Give You Up', 'artist': 'Rick Astley', 'platform': 'Spotify'},
              {'title': 'Love Story', 'artist': 'Taylor Swift', 'platform': 'Spotify'},
            ],
          },
          {
            'title': 'My tranquility dose',
            'image': 'https://picsum.photos/150?random=2',
            'songs': [
              {'title': 'Bigcityboi', 'artist': 'Binz', 'platform': 'Spotify'},
              {'title': 'Cigarette', 'artist': 'offonoff', 'platform': 'Spotify'},
            ],
          },
        ],
        'singles': [
          {'title': 'Bigcityboi', 'artist': 'Binz', 'platform': 'Spotify'},
          {'title': 'Never Gonna Give You Up', 'artist': 'Rick Astley', 'platform': 'Spotify'},
        ],
      },
      'Apple Music': {
        'playlists': [
          {
            'title': 'Richie richie richie',
            'image': 'https://picsum.photos/150?random=3',
            'songs': [
              {'title': 'Edamame', 'artist': 'Artist 1', 'platform': 'Apple Music'},
              {'title': 'Song 2', 'artist': 'Artist 2', 'platform': 'Apple Music'},
            ],
          },
        ],
        'singles': [
          {'title': 'Edamame', 'artist': 'Artist 1', 'platform': 'Apple Music'},
        ],
      },
      'YouTube': {
        'playlists': [
          {
            'title': 'Workout monster',
            'image': 'https://picsum.photos/150?random=4',
            'songs': [
              {'title': 'Boom', 'artist': 'Tiesto, Seven', 'platform': 'YouTube'},
              {'title': 'Nocturne Op. 9 No. 2', 'artist': 'Chopin', 'platform': 'YouTube'},
            ],
          },
        ],
        'singles': [
          {'title': 'Anysong', 'artist': 'Zico', 'platform': 'YouTube'},
          {'title': "Can't get you out of my head", 'artist': 'Khalid', 'platform': 'YouTube'},
        ],
      },
      'SoundCloud': {
        'playlists': [
          {
            'title': 'coOl sTuFF',
            'image': 'https://picsum.photos/150?random=5',
            'songs': [
              {'title': 'Song 3', 'artist': 'Artist 3', 'platform': 'SoundCloud'},
              {'title': 'Song 4', 'artist': 'Artist 4', 'platform': 'SoundCloud'},
            ],
          },
        ],
        'singles': [],
      },
    };

    final List<Map<String, dynamic>> playlists = appData[appName]!['playlists'] ?? [];
    final List<Map<String, dynamic>> singles = appData[appName]!['singles'] ?? [];

    // Danh sách bài hát giả lập
  final List<Map<String, dynamic>> songs = [
    {
      'title': 'Never Gonna Give You Up',
      'artist': 'Rick Astley',
      'audioUrl': 'https://example.com/never_gonna_give_you_up.mp3', // Thay bằng URL thật
      'lyrics': [
        {'time': 0, 'text': 'Never Gonna Give You Up'},
        {'time': 3000, 'text': 'Rick Astley'},
        {'time': 5000, 'text': 'We\'re no strangers to love'},
        {'time': 8000, 'text': 'You know the rules and so do I'},
        {'time': 11000, 'text': 'A full commitment\'s what I\'m thinking of'},
        {'time': 14000, 'text': 'You wouldn\'t get this from any other guy'},
        {'time': 17000, 'text': 'I just wanna tell you how I\'m feeling'},
        {'time': 20000, 'text': 'Gotta make you understand'},
        {'time': 23000, 'text': 'Never gonna give you up'},
        {'time': 26000, 'text': 'Never gonna let you down'},
        {'time': 29000, 'text': 'Never gonna run around and desert you'},
        {'time': 32000, 'text': 'Never gonna make you cry'},
        {'time': 35000, 'text': 'Never gonna say goodbye'},
      ],
    },
    {
      'title': 'Shape of You',
      'artist': 'Ed Sheeran',
      'audioUrl': 'https://example.com/shape_of_you.mp3',
      'lyrics': [
        {'time': 0, 'text': 'Shape of You'},
        {'time': 3000, 'text': 'Ed Sheeran'},
        {'time': 5000, 'text': 'The club isn\'t the best place to find a lover'},
        {'time': 8000, 'text': 'So the bar is where I go'},
      ],
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
                          Navigator.pop(context); // Quay lại ByResourcesScreen
                        },
                      ),
                      Expanded(
                        child: Text(
                          appName,
                          style: const TextStyle(
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

              // Playlists
              if (playlists.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Playlists',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[400],
                      ),
                    ),
                  ),
                ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final playlist = playlists[index];
                    return _buildPlaylistItem(
                      context,
                      playlist['title'],
                      playlist['image'],
                      playlist['songs'],
                    );
                  },
                  childCount: playlists.length,
                ),
              ),

              // Single songs
              if (singles.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Single songs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[400],
                      ),
                    ),
                  ),
                ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = singles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          // Điều hướng đến ASongScreen
                          Navigator.pushNamed(
                            context,
                            '/a_song',
                            arguments: {
                              'title': song['title'],
                              'artist': song['artist'],
                              'audioUrl': song['audioUrl'],
                              'lyrics': song['lyrics'],
                            },
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey, // Thay bằng ảnh bìa bài hát nếu có
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      song['artist'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
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
                    // return _buildSingleSongItem(
                    //   context,
                    //   song['title'],
                    //   song['artist'],
                    //   song['platform'],
                    // );
                  },
                  childCount: singles.length,
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

  // Widget cho mục playlist
  Widget _buildPlaylistItem(
    BuildContext context,
    String title,
    String imageUrl,
    List<Map<String, String>> songs,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          // Điều hướng đến PlaylistScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistScreen(
                playlistName: title,
                songs: songs,
              ),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }

  // Widget cho mục single song
  Widget _buildSingleSongItem(
    BuildContext context,
    String title,
    String artist,
    String platform,
  ) {
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
      case 'apple music':
        platformIcon = Icons.apple;
        platformColor = Colors.white;
        break;
      case 'soundcloud':
        platformIcon = Icons.cloud;
        platformColor = Colors.orange;
        break;
      default:
        platformIcon = Icons.music_note;
        platformColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          // Phát bài hát đơn lẻ
          print('Playing single song: $title by $artist');
        },
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
              const Icon(
                Icons.play_arrow,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}