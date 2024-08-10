import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// An extension on [AssetBundle] to facilitate loading images as [ui.Image].
extension RootBundleImage on AssetBundle {
  /// Loads an image from the asset bundle using the provided [key].
  ///
  /// This method reads the asset identified by [key], decodes it as an image,
  /// and returns a [ui.Image] object that can be used for custom painting.
  ///
  /// Example:
  /// ```dart
  /// final ui.Image image = await rootBundle.loadImage('assets/my_image.png');
  /// ```
  ///
  /// Throws an exception if the asset cannot be loaded or if the image cannot
  /// be decoded.
  ///
  /// - [key]: The key that identifies the asset to be loaded.
  ///
  /// Returns a [Future] that completes with the decoded [ui.Image].
  Future<ui.Image> loadImage(String key) async {
    final bd = await load(key);
    final bytes = Uint8List.view(bd.buffer);
    final codec = await ui.instantiateImageCodec(bytes);
    return (await codec.getNextFrame()).image;
  }
}
