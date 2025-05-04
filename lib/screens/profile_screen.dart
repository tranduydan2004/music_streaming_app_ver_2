import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'edit_profile_screen.dart';
import 'scan_qr_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  String? _firstName;
  String? _lastName;
  String? _pronouns;
  bool _isPublic = true;
  bool _showStats = true;
  
  String? _imagePath; // Đường dẫn ảnh đại diện

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _username = prefs.getString('username') ?? 'Unknown User';
      _firstName = prefs.getString('firstName');
      _lastName = prefs.getString('lastName');
      _pronouns = prefs.getString('pronouns');
      _isPublic = prefs.getBool('isPublic') ?? true;
      _showStats = prefs.getBool('showStats') ?? true;
      _imagePath = prefs.getString('imagePath'); // Tải ảnh đại diện từ SharedPreferences
      
    });
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
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Quay lại trang trước
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanQRScreen(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.qr_code, color: Colors.white),
                            onPressed: () {
                              _showQRCodeDialog(context, _username ?? 'Unknown User');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Nội dung chính
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Hiển thị ảnh đại diện
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: _imagePath != null
                              ? FileImage(File(_imagePath!))
                              : null,
                          child: _imagePath == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _username ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                currentUsername: _username ?? 'Unknown User',
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _username = result['username'];
                              _firstName = result['firstName'];
                              _lastName = result['lastName'];
                              _pronouns = result['pronouns'];
                              _isPublic = result['isPublic'];
                              _showStats = result['showStats'];
                              _imagePath = result['imagePath']; // Cập nhật ảnh đại diện
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'edit profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_firstName != null)
                        Text(
                          'First Name: $_firstName',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      if (_lastName != null)
                        Text(
                          'Last Name: $_lastName',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      if (_pronouns != null)
                        Text(
                          'Pronouns: $_pronouns',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        'Account Mode: ${_isPublic ? 'Public' : 'Private'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Show Stats: ${_showStats ? 'Enabled' : 'Disabled'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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
        currentIndex: 3, // Chọn tab Profile
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home'); // Chuyển sang trang Home
          } else if (index == 1) {
            Navigator.pushNamed(context, '/browse'); // Chuyển sang trang Browse
          } else if (index == 2) {
            Navigator.pushNamed(context, '/library'); // Chuyển sang trang Library
          } else if (index == 4) {
            Navigator.pushNamed(context, '/setting'); // Chuyển sang trang Settings
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

  // Hàm hiển thị dialog chứa mã QR
  void _showQRCodeDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF920A92),
          title: const Text(
            'Your Profile QR Code',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: QrImageView(
                      data: username,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Scan this QR code to visit $username',
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }
}