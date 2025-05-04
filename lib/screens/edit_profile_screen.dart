import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentUsername;

  const EditProfileScreen({super.key, required this.currentUsername});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isPublic = true; // Trạng thái Account mode (Public/Private)
  bool showStats = true; // Trạng thái Interaction statistics (Show/Hide)
  File? _selectedImage; // Ảnh được chọn

  // TextEditingController để theo dõi giá trị các trường
  late TextEditingController usernameController;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController pronounsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.currentUsername);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString('firstName') ?? '';
      lastNameController.text = prefs.getString('lastName') ?? '';
      pronounsController.text = prefs.getString('pronouns') ?? '';
      isPublic = prefs.getBool('isPublic') ?? true;
      showStats = prefs.getBool('showStats') ?? true;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    pronounsController.dispose();
    super.dispose();
  }

  // Hàm chọn ảnh từ thư viện hoặc camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Hàm kiểm tra username và lưu thông tin
  void _checkUsernameAndSave(BuildContext context) async {
    String newUsername = usernameController.text.trim();

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Username cannot be empty'),
        ),
      );
      return;
    }

    // Lưu thông tin vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
    await prefs.setString('firstName', firstNameController.text.trim());
    await prefs.setString('lastName', lastNameController.text.trim());
    await prefs.setString('pronouns', pronounsController.text.trim());
    await prefs.setBool('isPublic', isPublic);
    await prefs.setBool('showStats', showStats);

    // Lưu đường dẫn ảnh (nếu có)
  if (_selectedImage != null) {
    await prefs.setString('imagePath', _selectedImage!.path);
  }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Profile updated successfully!'),
      ),
    );

    // Trả về thông tin đã chỉnh sửa
    Navigator.pop(context, {
      'username': newUsername,
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'pronouns': pronounsController.text.trim(),
      'isPublic': isPublic,
      'showStats': showStats,
      'imagePath': _selectedImage?.path, // Trả về đường dẫn ảnh (nếu có)
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
          child: Column(
            children: [
              // TopBar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Hủy và quay lại Profile
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        _checkUsernameAndSave(context); // Kiểm tra username và lưu
                      },
                    ),
                  ],
                ),
              ),

              // Nội dung chính
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Avatar
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : null,
                                child: _selectedImage == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.black,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _showImageSourceDialog();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Trường nhập liệu
                        _buildTextField('Username', usernameController),
                        const SizedBox(height: 20),
                        _buildTextField('First name', firstNameController),
                        const SizedBox(height: 20),
                        _buildTextField('Last name', lastNameController),
                        const SizedBox(height: 20),
                        _buildTextField('Pronouns', pronounsController),
                        const SizedBox(height: 30),

                        // Account mode
                        const Text(
                          'Account mode',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildToggleButton('Public', isPublic, () {
                              setState(() {
                                isPublic = true;
                              });
                            }),
                            const SizedBox(width: 10),
                            _buildToggleButton('Private', !isPublic, () {
                              setState(() {
                                isPublic = false;
                              });
                            }),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Interaction statistics
                        const Text(
                          'Interaction statistics',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildToggleButton('Show', showStats, () {
                              setState(() {
                                showStats = true;
                              });
                            }),
                            const SizedBox(width: 10),
                            _buildToggleButton('Hide', !showStats, () {
                              setState(() {
                                showStats = false;
                              });
                            }),
                          ],
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hiển thị hộp thoại chọn nguồn ảnh
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  // Widget cho trường nhập liệu
  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
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
      ],
    );
  }

  // Widget cho nút toggle
  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}