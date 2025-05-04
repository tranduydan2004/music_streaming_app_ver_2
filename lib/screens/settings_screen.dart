import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) onThemeChanged;
  final Function(String) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _theme = 'Light'; // Chủ đề mặc định
  String _language = 'English'; // Ngôn ngữ mặc định
  String _userName = 'Guest'; // Tên người dùng mặc định

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Tải cài đặt từ SharedPreferences
  }

  // Hàm tải cài đặt từ SharedPreferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = prefs.getString('theme') ?? 'Light';
      _language = prefs.getString('language') ?? 'English';
      _userName = prefs.getString('username') ?? 'Guest';
    });
  }

  // Hàm lưu cài đặt vào SharedPreferences
  Future<void> _saveSetting(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Hiển thị hộp thoại xác nhận đăng xuất
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF920A92),
          title: const Text(
            'Xác nhận đăng xuất',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.pink),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: CustomScrollView(
            slivers: [
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
                          Navigator.pop(context);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Cài đặt',
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
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào, $_userName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Giao diện',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Chủ đề',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: DropdownButton<String>(
                            value: _theme,
                            dropdownColor: const Color(0xFF920A92),
                            items: const [
                              DropdownMenuItem(
                                value: 'Light',
                                child: Text('Sáng', style: TextStyle(color: Colors.white)),
                              ),
                              DropdownMenuItem(
                                value: 'Dark',
                                child: Text('Tối', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _theme = value;
                                });
                                widget.onThemeChanged(value); // Gọi callback để thay đổi chủ đề
                                _saveSetting('theme', value);
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Ngôn ngữ',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: DropdownButton<String>(
                            value: _language,
                            dropdownColor: const Color(0xFF920A92),
                            items: const [
                              DropdownMenuItem(
                                value: 'English',
                                child: Text('Tiếng Anh', style: TextStyle(color: Colors.white)),
                              ),
                              DropdownMenuItem(
                                value: 'Vietnamese',
                                child: Text('Tiếng Việt', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _language = value;
                                });
                                widget.onLanguageChanged(value); // Gọi callback để thay đổi ngôn ngữ
                                _saveSetting('language', value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Bộ nhớ',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Xóa bộ nhớ cache',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đã xóa bộ nhớ cache')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Thông tin ứng dụng',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Phiên bản',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '1.0.0',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tài khoản',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Đăng xuất',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
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
        currentIndex: 4, // Chọn tab Settings
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/browse');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/by_resources');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
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
}