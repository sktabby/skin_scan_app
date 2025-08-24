import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'live_camera_page.dart';
import 'profile_page.dart';
import 'categories.dart';
import 'images_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  late Interpreter _interpreter;
  final List<String> _imagePaths = [];
  String _result = '';
  bool _modelLoaded = false;

  final List<String> _labels = [
    "Actinic Keratosis",
    "Basal Cell Carcinoma",
    "Dermatofibroma",
    "Melanoma",
    "Nevus",
    "Pigmented Benign Keratosis",
    "Seborrheic Keratosis",
    "Squamous Cell Carcinoma",
    "Vascular Lesion",
  ];

  final int _inputSize = 224;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Ensure model is listed in pubspec.yaml under assets
      _interpreter = await Interpreter.fromAsset('assets/best_skin_model.tflite');
      debugPrint('✅ TFLite model loaded');
      setState(() => _modelLoaded = true);
    } catch (e) {
      debugPrint('❌ Error loading model: $e');
    }
  }

  Future<void> _runModel(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image image = img.decodeImage(bytes)!;

      image = img.copyResize(image, width: _inputSize, height: _inputSize);

      var input = List.generate(1, (_) =>
        List.generate(_inputSize, (y) =>
          List.generate(_inputSize, (x) {
            final px = image.getPixel(x, y);
            return [
              (px.r - 127.5) / 127.5,
              (px.g - 127.5) / 127.5,
              (px.b - 127.5) / 127.5,
            ];
          })));
      var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
      _interpreter.run(input, output);

      final probs = List<double>.from(output[0]);
      final maxIdx = probs.indexWhere((p) => p == probs.reduce((a, b) => a > b ? a : b));

      setState(() => _result = '${_labels[maxIdx]} (${(probs[maxIdx] * 100).toStringAsFixed(1)}%)');
    } catch (e) {
      debugPrint('❌ Error during inference: $e');
      setState(() => _result = 'Inference error');
    }
  }

  Future<void> _openCamera() async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model is still loading...'))
      );
      return;
    }
    final XFile? imgFile = await _picker.pickImage(source: ImageSource.camera);
    if (imgFile != null) {
      setState(() => _imagePaths.add(imgFile.path));
      await _runModel(File(imgFile.path));
    }
  }

  Future<void> _pickFromGallery() async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model is still loading...'))
      );
      return;
    }
    final XFile? imgFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      setState(() => _imagePaths.add(imgFile.path));
      await _runModel(File(imgFile.path));
    }
  }

  void _navigateToImagesPage() {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => ImagesPage(imagePaths: _imagePaths)),
    );
  }

  void _navigateToProfile() {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => ProfilePage()),

    );
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_modelLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFFCFE8EF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFCFE8EF),
      appBar: AppBar(
        title: const Text('SkinScan',
            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightBlueAccent),
              child: const Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _drawerItem(Icons.home, 'HOME'),
            _drawerItem(Icons.category, 'CATEGORIES'),
            _drawerItem(Icons.image, 'IMAGES'),
            _drawerItem(Icons.report, 'REPORT'),
            _drawerItem(Icons.contact_mail, 'CONTACT US'),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_result.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Text('Prediction: $_result', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          Center(
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 80, color: Colors.black),
                onPressed: _openCamera,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickFromGallery,
            icon: const Icon(Icons.photo_library, color: Colors.blue),
            label: const Text('UPLOAD FROM GALLERY', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.blue, width: 1.5),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveCameraPage()),
              );
            },
            icon: const Icon(Icons.live_tv, color: Colors.red),
            label: const Text('LIVE CAMERA', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.camera, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            const SizedBox(width: 50),
            IconButton(icon: const Icon(Icons.person), onPressed: _navigateToProfile),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title,
          style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        if (title == 'CATEGORIES') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriesPage()));
        } else if (title == 'IMAGES') {
          _navigateToImagesPage();
        }
      },
    );
  }
}
