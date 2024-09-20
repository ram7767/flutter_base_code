import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class SaveScreen extends StatelessWidget {
  final List<TextBlock> textBlocks;

  SaveScreen({required this.textBlocks});

  Future<void> _saveToFile(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/output.txt');
    await file.writeAsString(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Save Text')),
      body: ListView.builder(
        itemCount: textBlocks.length,
        itemBuilder: (context, index) {
          return TextField(
            decoration:
                InputDecoration(labelText: 'Heading for Line ${index + 1}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Combine text from textFields and save
          String combinedText =
              "Combined Text Here"; // Replace with actual text
          _saveToFile(combinedText);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
