import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// A page that shows live camera preview and runs TFLite inference on frames.
class LiveCameraPage extends StatefulWidget {
  const LiveCameraPage({super.key});

  @override
  State<LiveCameraPage> createState() => _LiveCameraPageState();
}

class _LiveCameraPageState extends State<LiveCameraPage> {
  late final CameraController _cameraController;
  late final Interpreter _interpreter;
  bool _isDetecting = false;
  String _result = '';

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

  static const int _inputSize = 224;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // 1) Initialize camera
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
    await _cameraController.startImageStream(_processCameraImage);

    // 2) Load model
    _interpreter = await Interpreter.fromAsset('assets/best_skin_model.tflite');

    setState(() {});
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;
    try {
      // Convert YUV420 to RGB img.Image
      final img.Image converted = _convertYUV420toImage(image);
      final img.Image resized = img.copyResize(
        converted,
        width: _inputSize,
        height: _inputSize,
      );

      // Prepare input tensor
      final input = List.generate(
        1,
        (_) => List.generate(
          _inputSize,
          (y) => List.generate(
            _inputSize,
            (x) {
              final px = resized.getPixel(x, y);
              return [
                (px.r - 127.5) / 127.5,
                (px.g - 127.5) / 127.5,
                (px.b - 127.5) / 127.5,
              ];
            },
          ),
        ),
      );

      // Prepare output buffer
      final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

      // Run inference
      _interpreter.run(input, output);

      // Extract best result
      final probs = List<double>.from(output[0]);
      final maxIdx = probs.indexWhere((p) => p == probs.reduce((a, b) => a > b ? a : b));

      setState(() {
        _result = '${_labels[maxIdx]} (${(probs[maxIdx] * 100).toStringAsFixed(1)}%)';
      });
    } catch (e) {
      setState(() => _result = 'Error during detection');
    }

    // throttle
    await Future.delayed(const Duration(seconds: 1));
    _isDetecting = false;
  }

  img.Image _convertYUV420toImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imgBuffer = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = (y >> 1) * (width >> 1) + (x >> 1);
        final int yp = image.planes[0].bytes[y * width + x];
        final int up = image.planes[1].bytes[uvIndex];
        final int vp = image.planes[2].bytes[uvIndex];

        int r = (yp + 1.370705 * (vp - 128)).round();
        int g = (yp - 0.698001 * (vp - 128) - 0.337633 * (up - 128)).round();
        int b = (yp + 1.732446 * (up - 128)).round();

        imgBuffer.setPixelRgba(
          x,
          y,
          r.clamp(0, 255),
          g.clamp(0, 255),
          b.clamp(0, 255),
          255,
        );
      }
    }
    return imgBuffer;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(_cameraController.value.isInitialized)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live Skin Detection')),
      body: Stack(
        children: [
          CameraPreview(_cameraController),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _result,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}