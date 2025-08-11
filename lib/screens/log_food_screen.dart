import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LogFoodScreen extends StatefulWidget {
  const LogFoodScreen({super.key});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) setState(() => _image = picked);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Log Food', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Take Photo (AI identify)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Barcode'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search),
              label: const Text('Search Food Manually'),
            ),
            const SizedBox(height: 16),
            if (_image != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.file(
                        File(_image!.path),
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      const Text('Image ready to send to AI for recognition'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}