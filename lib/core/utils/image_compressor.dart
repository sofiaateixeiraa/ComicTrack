import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// comprime imagens para caberem no documento do Firestore, limite de 1MB.
class ImageCompressor {
  static const int defaultMaxBytes = 700 * 1024;

  static Future<Uint8List> compress(
    Uint8List bytes, {
    int maxBytes = defaultMaxBytes,
  }) {
    return compute(_compressSync, _CompressArgs(bytes, maxBytes));
  }

  static Uint8List _compressSync(_CompressArgs args) {
    final decoded = img.decodeImage(args.bytes);
    if (decoded == null) return args.bytes;

    var working = decoded;
    var quality = 90;
    var result = Uint8List.fromList(img.encodeJpg(working, quality: quality));

    // reduz a qualidade da compressão jpg.
    while (result.lengthInBytes > args.maxBytes && quality > 20) {
      quality -= 15;
      result = Uint8List.fromList(img.encodeJpg(working, quality: quality));
    }

    // se ainda não for suficiente, reduz também as dimensões.
    while (result.lengthInBytes > args.maxBytes && working.width > 200) {
      working = img.copyResize(working, width: (working.width * 0.75).round());
      result = Uint8List.fromList(img.encodeJpg(working, quality: quality));
    }

    return result;
  }
}

class _CompressArgs {
  final Uint8List bytes;
  final int maxBytes;
  const _CompressArgs(this.bytes, this.maxBytes);
}
