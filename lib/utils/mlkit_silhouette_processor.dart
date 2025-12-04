import 'dart:io';
import 'package:google_mlkit_subject_segmentation/google_mlkit_subject_segmentation.dart';
import 'package:image/image.dart' as img;

class MLKitSilhouetteProcessor {
  SubjectSegmenter? _segmenter;
  bool _isInitialized = false;

  /// ML Kitの初期化
  Future<void> initialize() async {
    if (_isInitialized) return;

    final options = SubjectSegmenterOptions(
      enableForegroundBitmap: true,
      enableForegroundConfidenceMask: false,
      enableMultipleSubjects: SubjectResultOptions(
        enableConfidenceMask: false,
        enableSubjectBitmap: false,
      ),
    );
    _segmenter = SubjectSegmenter(options: options);
    _isInitialized = true;
  }

  /// 写真からシルエット画像を生成
  /// 入力：写真ファイルのパス
  /// 出力：生成されたシルエット画像のパス（PNG形式、背景白）
  Future<String> createSilhouette(String inputPath) async {
    if (!_isInitialized) {
      await initialize();
    }

    final file = File(inputPath);
    if (!file.existsSync()) {
      throw Exception("Image not found: $inputPath");
    }

    // InputImageを作成
    final inputImage = InputImage.fromFilePath(inputPath);

    // 被写体セグメンテーション実行
    final result = await _segmenter!.processImage(inputImage);

    // 元画像を読み込み
    final bytes = await file.readAsBytes();
    final img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception("Failed to decode image");
    }

    // ML Kitの結果に基づいてシルエット生成
    final maskBytes = result.foregroundBitmap;
    img.Image silhouette;

    print('DEBUG: maskBytes is ${maskBytes == null ? "null" : "not null (${maskBytes.length} bytes)"}');

    if (maskBytes != null) {
      final img.Image? maskImage = img.decodeImage(maskBytes);
      print('DEBUG: maskImage decoded: ${maskImage != null ? "${maskImage.width}x${maskImage.height}" : "failed"}');
      if (maskImage == null) {
        throw Exception("Failed to decode segmentation mask");
      }
      silhouette = _createSilhouetteFromMask(
        maskImage,
        originalWidth: originalImage.width,
        originalHeight: originalImage.height,
      );
    } else {
      print('DEBUG: No mask from ML Kit, using fallback');
      silhouette = _createSilhouetteFromOriginal(originalImage);
    }

    // PNG形式で保存（透明度を保持）
    final outputPath = inputPath.replaceAll(
      RegExp(r'\.(jpg|jpeg)$', caseSensitive: false),
      '_silhouette.png',
    );
    final outFile = File(outputPath);
    await outFile.writeAsBytes(img.encodePng(silhouette));

    return outputPath;
  }

  /// リソースの解放
  Future<void> dispose() async {
    if (_isInitialized && _segmenter != null) {
      await _segmenter!.close();
      _isInitialized = false;
    }
  }

  img.Image _createSilhouetteFromMask(
    img.Image maskImage, {
    required int originalWidth,
    required int originalHeight,
  }) {
    const int maskThreshold = 16;
    img.Image silhouette = img.Image(
      width: maskImage.width,
      height: maskImage.height,
    );

    for (int y = 0; y < maskImage.height; y++) {
      for (int x = 0; x < maskImage.width; x++) {
        final maskPixel = maskImage.getPixel(x, y);
        final intensity = maskPixel.r.toInt();
        if (intensity > maskThreshold) {
          // 被写体 → 黒
          silhouette.setPixelRgba(x, y, 0, 0, 0, 255);
        } else {
          // 背景 → 白
          silhouette.setPixelRgba(x, y, 255, 255, 255, 255);
        }
      }
    }

    if (silhouette.width != originalWidth || silhouette.height != originalHeight) {
      silhouette = img.copyResize(
        silhouette,
        width: originalWidth,
        height: originalHeight,
        interpolation: img.Interpolation.nearest,
      );
    }

    return silhouette;
  }

  img.Image _createSilhouetteFromOriginal(img.Image originalImage) {
    final img.Image silhouette = img.Image(
      width: originalImage.width,
      height: originalImage.height,
    );

    for (int y = 0; y < originalImage.height; y++) {
      for (int x = 0; x < originalImage.width; x++) {
        final pixel = originalImage.getPixel(x, y);
        final luminance = pixel.luminance;
        if (luminance < 128) {
          silhouette.setPixelRgba(x, y, 0, 0, 0, 255);
        } else {
          silhouette.setPixelRgba(x, y, 255, 255, 255, 255);
        }
      }
    }

    return silhouette;
  }
}
