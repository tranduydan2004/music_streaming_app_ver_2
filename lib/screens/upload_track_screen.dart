import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';

class UploadTrackScreen extends StatefulWidget {
  const UploadTrackScreen({super.key});

  @override
  State<UploadTrackScreen> createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends State<UploadTrackScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  String? selectedGenre;
  bool isPublic = false;
  File? _selectedFile;

  final List<String> genres = [
    'Pop',
    'Hip hop',
    'Classical',
    'Jazz',
    'EDM',
    'Blues',
    'R&B',
    'Indie',
  ];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadTrack() async {
    if (titleController.text.isEmpty ||
        selectedGenre == null ||
        _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all required fields")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to upload")),
      );
      Navigator.pushNamed(
        context,
        '/signin',
      ); // Điều hướng đến màn hình đăng nhập
      return;
    }

    try {
      final uri = Api.uri('/music/upload');
      final request = http.MultipartRequest('POST', uri);

      // Add JWT token
      request.headers['Authorization'] = 'Bearer $token';

      // Add other fields
      request.fields['title'] = titleController.text;
      request.fields['genre'] = selectedGenre!;
      request.fields['caption'] = captionController.text;
      request.fields['public'] = isPublic.toString();

      // Add file
      final stream = http.ByteStream(_selectedFile!.openRead());
      final length = await _selectedFile!.length();
      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: path.basename(_selectedFile!.path),
      );
      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Upload successful")));
        Navigator.pop(context);
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Access denied. Please login again.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload error: $e")));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Track"),
        backgroundColor: const Color(0xFF920A92),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAFEEEE), Color(0xFF920A92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickFile,
                child:
                    _selectedFile != null
                        ? Text(
                          path.basename(_selectedFile!.path),
                          style: const TextStyle(color: Colors.white),
                        )
                        : Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.attach_file,
                            color: Colors.white70,
                          ),
                        ),
              ),
              const SizedBox(height: 20),
              _buildInputField("Title", "Describe your track", titleController),
              const SizedBox(height: 20),
              _buildGenreDropdown(),
              const SizedBox(height: 20),
              _buildInputField(
                "Caption",
                "Optional caption",
                captionController,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Make this track public",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: isPublic,
                    onChanged: (val) {
                      setState(() {
                        isPublic = val;
                      });
                    },
                    activeColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: _uploadTrack,
                icon: const Icon(Icons.cloud_upload, color: Colors.white),
                label: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Genre",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF920A92),
          value: selectedGenre,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          hint: const Text(
            "Pick a genre",
            style: TextStyle(color: Colors.white70),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          items:
              genres
                  .map(
                    (genre) =>
                        DropdownMenuItem(value: genre, child: Text(genre)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedGenre = value;
            });
          },
        ),
      ],
    );
  }
}
