import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';  // for debugPrint
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// Singleton service for loading a TFLite model and running inference.
class TFLiteService {
  late Interpreter _interpreter;

  /// Number of classification labels (adjust to your model)
  static const int numLabels = 9;

  /// Input image size expected by the model
  final int inputSize = 224;

  TFLiteService._privateConstructor();
  static final TFLiteService instance = TFLiteService._privateConstructor();

  /// Loads the TFLite model from assets. Call this before running any inference.
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets\best_skin_model.tflite');
      debugPrint('✅ TFLite model loaded successfully');
    } catch (e) {
      debugPrint('❌ Failed to load TFLite model: $e');
      rethrow;
    }
  }

  /// Runs model inference on [imageFile], returns a list of probabilities.
  Future<List<double>> predict(File imageFile) async {
    // Ensure model is loaded
    if (_interpreter == null) {
      throw StateError('Model not loaded. Call loadModel() before predict().');
    }

    // Decode the image
    final decoded = img.decodeImage(await imageFile.readAsBytes());
    if (decoded == null) {
      throw Exception('❌ Unable to decode image');
    }

    // Resize the image to the input size
    final resized = img.copyResize(decoded, width: inputSize, height: inputSize);

    // Convert image to Float32List buffer
    final inputBuffer = _imageToFloat32List(resized);

    // Prepare output buffer: [1, numLabels]
    final outputBuffer = List.generate(1, (_) => List.filled(numLabels, 0.0));

    try {
      // Run inference
      _interpreter.run(inputBuffer, outputBuffer);
    } catch (e) {
      debugPrint('❌ Inference error: $e');
      rethrow;
    }

    // Extract and return the probabilities
    return List<double>.from(outputBuffer[0]);
  }

  /// Converts [image] to a Float32List of shape [1,224,224,3], normalized to [0,1].
  Float32List _imageToFloat32List(img.Image image) {
    final Float32List buffer = Float32List(inputSize * inputSize * 3);
    int index = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final px = image.getPixel(x, y);
        // Pixel.r, .g, .b are 0-255
        buffer[index++] = px.r / 255.0;
        buffer[index++] = px.g / 255.0;
        buffer[index++] = px.b / 255.0;
      }
    }
    return buffer;
  }
}