import 'dart:io';
import 'package:image/image.dart' as img;

/// Preprocesses [imageFile] into a 4D List of shape [1, 224, 224, 3],
/// with pixel values normalized to [-1, 1].
Future<List<List<List<List<double>>>>> preprocessImage(File imageFile) async {
  // 1) Load and decode the image
  final bytes = await imageFile.readAsBytes();
  final original = img.decodeImage(bytes);
  if (original == null) throw Exception('❌ Failed to decode image.');

  // 2) Resize to 224×224
  final resized = img.copyResize(original, width: 224, height: 224);

  // 3) Create 4D input tensor: [1][224][224][3]
  final input = [
    List.generate(224, (y) =>
      List.generate(224, (x) {
        final pixel = resized.getPixel(x, y);
        return [
          (pixel.r - 127.5) / 127.5,
          (pixel.g - 127.5) / 127.5,
          (pixel.b - 127.5) / 127.5,
        ];
      })
    )
  ];

  return input;
}
