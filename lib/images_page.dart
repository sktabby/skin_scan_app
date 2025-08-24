import 'package:flutter/material.dart';
import 'dart:io';
import 'full_screen_image.dart';


class ImagesPage extends StatefulWidget {
  final List<String> imagePaths;

  ImagesPage({required this.imagePaths});

  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  void _viewFullScreen(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullScreenImage(imagePath: imagePath)),
    );
  }

  void _deleteImage(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Image"),
        content: Text("Are you sure you want to delete this image?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel deletion
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.imagePaths.removeAt(index); // Remove image from list
              });
              Navigator.pop(context); // Close dialog
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFE8EF),
      appBar: AppBar(
        title: Text(
          'Captured Images',
          style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: widget.imagePaths.isEmpty
          ? Center(
              child: Text(
                "No images captured yet!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _viewFullScreen(widget.imagePaths[index]), // Open full-screen view
                  onLongPress: () => _deleteImage(index), // Long-press to delete
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(File(widget.imagePaths[index]), fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
