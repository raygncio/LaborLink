import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborlink/ai/style.dart';

class IdScan extends StatelessWidget {
  const IdScan({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColors.grey),
              ),
              height: 250,
              width: double.infinity,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Hero(
                  tag: 'imageHero',
                  child: Image.file(
                    image,
                  ),
                ),
                onDoubleTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ImageZoom(previewImage: image),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageZoom extends StatelessWidget {
  const ImageZoom({super.key, required this.previewImage});

  final File? previewImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.file(previewImage!),
          ),
        ),
        onDoubleTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
