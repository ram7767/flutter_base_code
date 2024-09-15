import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:html' as html; // For web environment
// For Uint8List
import 'package:flutter/foundation.dart'; // For kIsWeb

import 'dart:io' as io; // Import for mobile

class ImageWidget extends StatelessWidget {
  final dynamic imageFile; // Handle both XFile and html.File

  const ImageWidget({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: imageFile != null
          ? (kIsWeb
              ? FutureBuilder<Uint8List>(
                  future: _getImageBytes(imageFile),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return Image.memory(
                          snapshot.data!); // Web case: Use Image.memory
                    } else {
                      return const Center(child: Text('No Image Data'));
                    }
                  },
                )
              : Image.file(io.File(imageFile.path))) // Mobile case: Use File
          : const Center(child: Text('No Image Selected')),
    );
  }

  // Helper method to convert html.File to Uint8List
  Future<Uint8List> _getImageBytes(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();

    reader.onLoadEnd.listen((e) {
      completer.complete(reader.result as Uint8List);
    });

    reader.readAsArrayBuffer(file);
    return completer.future;
  }
}
