import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/browse_screen.dart';
import 'screens/library_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/login_success_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/support_screen.dart';
import 'screens/upload_track_screen.dart';
import 'screens/playlist_screen.dart';
import 'screens/scan_qr_screen.dart';
import 'screens/by_resources_screen.dart';
import 'screens/a_song_screen.dart';
import 'screens/all_song_screen.dart';
import 'screens/a_song_share_link_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_profile_screen.dart';

void main() {
  runApp(const MusicStreamingApp());
}

class MusicStreamingApp extends StatefulWidget {
  const MusicStreamingApp({super.key});

  @override
  State<MusicStreamingApp> createState() => _MusicStreamingAppState();
}

class _MusicStreamingAppState extends State<MusicStreamingApp> {
  ThemeMode _themeMode = ThemeMode.light; // Chủ đề mặc định
  Locale _locale = const Locale('en'); // Ngôn ngữ mặc định

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Tải cài đặt từ SharedPreferences
  }

  // Hàm tải cài đặt từ SharedPreferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString('theme') ?? 'Light';
    String language = prefs.getString('language') ?? 'English';

    setState(() {
      _themeMode = theme == 'Dark' ? ThemeMode.dark : ThemeMode.light;
      _locale = language == 'Vietnamese' ? const Locale('vi') : const Locale('en');
    });
  }

  // Hàm thay đổi chủ đề
  void _changeTheme(String theme) {
    setState(() {
      _themeMode = theme == 'Dark' ? ThemeMode.dark : ThemeMode.light;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('theme', theme);
    });
  }

  // Hàm thay đổi ngôn ngữ
  void _changeLanguage(String language) {
    setState(() {
      _locale = language == 'Vietnamese' ? const Locale('vi') : const Locale('en');
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('language', language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DNAHUABRACA',
      theme: ThemeData.light(), // Chủ đề sáng
      darkTheme: ThemeData.dark(), // Chủ đề tối
      themeMode: _themeMode, // Áp dụng chủ đề
      locale: _locale, // Áp dụng ngôn ngữ
      supportedLocales: const [
        Locale('en', ''), // Tiếng Anh
        Locale('vi', ''), // Tiếng Việt
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/signup', // Route mặc định
      routes: {
        '/': (context) => const SignUpScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
        '/login_success': (context) => const LoginSuccessScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/support': (context) => const SupportScreen(),
        '/browse': (context) => const BrowseScreen(),
        '/library': (context) => const LibraryScreen(),
        '/upload': (context) => const UploadTrackScreen(),
        '/playlist': (context) => const PlaylistScreen(
          playlistName: 'Default Playlist',
          songs: [],
        ),
        '/scan_qr': (context) => const ScanQRScreen(),
        '/by_resources': (context) => const ByResourcesScreen(),
        '/setting': (context) => SettingsScreen(
              onThemeChanged: _changeTheme,
              onLanguageChanged: _changeLanguage,
            ),
        '/all_songs': (context) => const AllSongsScreen(),
        '/edit_profile': (context) => EditProfileScreen(currentUsername: ''),
      },
      onGenerateRoute: (settings) {
        // Route for song details page
        if (settings.name == '/a_song') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey('songId')) {
            return MaterialPageRoute(
              builder: (context) => ASongScreen(
                songId: args['songId'],
                title: args['title'],
              ),
            );
          } else {
            debugPrint('Error: Missing songId for /a_song');
            return _errorRoute('Missing songId for /a_song');
          }
        }

        // Route for sharing song link page
        if (settings.name == '/a_song_share_link') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null &&
              args.containsKey('title') &&
              args.containsKey('artist') &&
              args.containsKey('shareUrl')) {
            return MaterialPageRoute(
              builder: (context) => ASongShareLinkScreen(
                title: args['title'],
                artist: args['artist'],
                shareUrl: args['shareUrl'],
              ),
            );
          } else {
            debugPrint('Error: Missing data for /a_song_share_link');
            return _errorRoute('Missing data for /a_song_share_link');
          }
        }

        // Default error route
        debugPrint('Error: Route not found - ${settings.name}');
        return _errorRoute('404 - Not Found');
      },
    );
  }

  // Hàm hiển thị màn hình lỗi
  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}