import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// Custom Image Viewer to handle aspectRatio of Image

class CustomImageViewer extends StatelessWidget {
  final String imageUrl;
  CustomImageViewer({this.imageUrl});

  Future<ui.Image> _getImage() {
    Completer<ui.Image> completer = new Completer<ui.Image>();
    NetworkImage(imageUrl)
      .resolve( ImageConfiguration())
      .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          completer.complete(info.image);
        })
      );
        
    return completer.future;
  }

  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData) {
          ui.Image image = snapshot.data;
          return AspectRatio(
            aspectRatio: image.width / image.height,
            child: Image.network(imageUrl));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}