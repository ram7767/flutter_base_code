import 'dart:html' as html; // For web environment
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';
import '../widgets/image_widget.dart';
import '../widgets/json_table_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  html.File? _imageFile; // Use html.File for web
  bool _isLoading = false;
  Map<String, dynamic>? _jsonResponse; // Holds the API response
  bool _isServerConnected = false; // Server connection status

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Perform async work outside of setState
      final bytes = await pickedFile.readAsBytes();
      final file = html.File([bytes], pickedFile.name);

      // Update state synchronously
      setState(() {
        _imageFile = file;
      });
    }
  }

  Future<void> _submitImage() async {
    if (_imageFile != null) {
      setState(() {
        _isLoading = true;
      });

      // Use the ImageService to upload the image
      final response = await ImageService.uploadImage(_imageFile!);

      // Update state synchronously
      setState(() {
        _isLoading = false;
        _jsonResponse = response; // Store the response
      });
    }
  }

  Future<void> _pingServer() async {
    final isConnected = await ImageService.pingServer();
    setState(() {
      _isServerConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageWidget(imageFile: _imageFile),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitImage,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pingServer,
              child: const Text('Ping Server'),
            ),
            const SizedBox(height: 20),
            _isServerConnected
                ? Icon(Icons.check_circle, color: Colors.green, size: 40)
                : Icon(Icons.cancel, color: Colors.red, size: 40),
            const SizedBox(height: 20),
            // Display JSON response as a table if available
            _jsonResponse != null
                ? JsonTableWidget(jsonData: _jsonResponse!)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
