import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  String _scanResult = 'Chưa quét mã QR'; // Biến lưu kết quả quét
  bool _isScanning = false; // Biến để kiểm tra trạng thái quét

  // Hàm quét mã QR
  Future<void> _scanQR() async {
    setState(() {
      _isScanning = true;
    });

    try {
      // Gọi BarcodeScanner để quét mã QR
      ScanResult result = await BarcodeScanner.scan(
        options: const ScanOptions(
          restrictFormat: [BarcodeFormat.qr], // Chỉ quét mã QR
          useCamera: -1, // Sử dụng camera mặc định
          autoEnableFlash: false, // Tắt flash tự động
          android: AndroidOptions(
            useAutoFocus: true, // Bật tự động lấy nét trên Android
          ),
        ),
      );

      // Kiểm tra kết quả quét
      if (!mounted) return; // Đảm bảo widget vẫn tồn tại
      setState(() {
        if (result.rawContent.isEmpty) {
          // Người dùng hủy quét hoặc không quét được
          _scanResult = 'Quét mã QR bị hủy';
        } else {
          // Quét thành công
          _scanResult = result.rawContent;
        }
        _isScanning = false;
      });
    } catch (e) {
      // Xử lý lỗi
      if (!mounted) return;
      setState(() {
        _scanResult = 'Lỗi khi quét mã QR: $e';
        _isScanning = false;
      });
    }
  }

  // Widget TopBar
  Widget _buildTopBar() {
    return Padding(
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
              Navigator.pop(context); // Quay lại màn hình trước
            },
          ),
          const Expanded(
            child: Text(
              'Quét mã QR',
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
    );
  }

  // Widget Scan Section (hiển thị kết quả và nút quét)
  Widget _buildScanSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hiển thị kết quả quét
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _scanResult,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // Nút quét mã QR
          ElevatedButton(
            onPressed: _isScanning ? null : _scanQR,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isScanning
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text(
                    'Quét mã QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          // Nếu kết quả quét là một URL, hiển thị nút mở liên kết
          if (_scanResult.startsWith('http'))
            TextButton(
              onPressed: () async {
                if (await canLaunch(_scanResult)) {
                  await launch(_scanResult);
                } else {
                  throw 'Không thể mở liên kết $_scanResult';
                }
              },
              child: const Text('Mở liên kết'),
            ),
          // Nếu không phải URL, cho phép copy kết quả vào clipboard
          if (!_scanResult.startsWith('http'))
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _scanResult));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã sao chép!')),
                );
              },
            ),
        ],
      ),
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
              Color(0xFFAFEEEE), // Màu gradient trên
              Color(0xFF920A92), // Màu gradient dưới
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // TopBar
              SliverToBoxAdapter(child: _buildTopBar()),
              // Nội dung quét mã QR
              SliverToBoxAdapter(child: _buildScanSection()),
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
        selectedItemColor: Colors.white,
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
