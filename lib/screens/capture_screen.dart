import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'save_screen.dart';

class CaptureScreen extends StatefulWidget {
  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath; // Initialize as nullable
  List<TextBlock> _textBlocks = [];

  Future<void> _captureImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // Set image path
      });
      await _extractText();
    }
  }

  Future<void> _extractText() async {
    if (_imagePath == null) return; // Early return if not initialized
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(_imagePath!));
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    setState(() {
      _textBlocks = visionText.blocks; // Store the text blocks
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Image')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _captureImage,
            child: Text('Capture Image'),
          ),
          if (_imagePath != null)
            Image.file(File(_imagePath!)), // Use null check
          ElevatedButton(
            onPressed: () {
              if (_textBlocks.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaveScreen(textBlocks: _textBlocks),
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _imagePath = null; // Reset image path
                _textBlocks = [];
              });
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
