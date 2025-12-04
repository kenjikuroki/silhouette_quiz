import 'dart:io';
import 'package:image/image.dart' as img;

class SilhouetteProcessor {
  /// 入力：写真ファイルのパス
  /// 出力：生成されたシルエット画像のパス
  static Future<String> createSilhouette(String inputPath) async {
    final file = File(inputPath);
    if (!file.existsSync()) {
      throw Exception("Image not found: $inputPath");
    }

    // 画像読み込み
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Failed to decode image.");
    }

    // グレースケール化
    img.Image grayscale = img.grayscale(image);

    // 二値化（影処理）
    // しきい値は 128（調整可能）
    const threshold = 128;

    img.Image silhouette = img.Image.from(grayscale);

    for (int y = 0; y < silhouette.height; y++) {
      for (int x = 0; x < silhouette.width; x++) {
        final pixel = silhouette.getPixel(x, y);
        final l = img.getLuminance(pixel);

        if (l < threshold) {
          // 黒にする
          silhouette.setPixelRgba(x, y, 0, 0, 0, 255);
        } else {
          // 白にする
          silhouette.setPixelRgba(x, y, 255, 255, 255, 255);
        }
      }
    }

    // 保存
    final outputPath = inputPath.replaceAll(".jpg", "_silhouette.jpg");
    final outFile = File(outputPath);
    await outFile.writeAsBytes(img.encodeJpg(silhouette, quality: 100));

    return outputPath;
  }
}
