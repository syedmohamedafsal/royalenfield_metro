import 'package:flutter/material.dart';

class ImageSequence extends StatefulWidget {
  // path relative to directory at pubspec.yaml level
  final String imageRelativePath;

  // image file name increment, 1 if files in order of 0001.png, 0002.png ...
  final int imageNameIncrement;

  // length of each file name, 4 if file names like 0001.png
  final int imageNameLength;

  // file format of each image, like ".png", ".jpg", etc.
  final String imageFileFormat;

  // total number of images in the sequence
  final int totalImages;

  // current image to render, controlled from outside
  final int currentImage;

  const ImageSequence({
    required this.imageRelativePath,
    required this.imageFileFormat,
    required this.imageNameIncrement,
    required this.imageNameLength,
    required this.totalImages,
    required this.currentImage,
    Key? key,
  }) : super(key: key);

  @override
  _ImageSequenceState createState() => _ImageSequenceState();
}

class _ImageSequenceState extends State<ImageSequence> {
  int previousFrame = 0;
  late Widget currentFrame;

  @override
  void initState() {
    super.initState();
    currentFrame = const SizedBox();
  }

  String getSuffix(String value) {
    while (value.length < widget.imageNameLength) value = "0" + value;
    return value;
  }

  String getDirectory() {
    return widget.imageRelativePath +
        getSuffix((widget.imageNameIncrement + previousFrame).toString()) +
        widget.imageFileFormat;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentImage != null) {
      if (widget.currentImage != previousFrame) {
        previousFrame = widget.currentImage!;
        if (previousFrame < widget.totalImages)
          currentFrame = Image.asset(
            getDirectory(),
            gaplessPlayback: true,
          );
      }
    }
    return currentFrame;
  }
}
