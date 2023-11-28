
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({super.key, required this.images, required this.regulaResults});

  final List<Image> images;
  final List<double> regulaResults;

  @override
  Widget build(BuildContext context) {
    print(images);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 200,
            child: images[0],
          ),
          Container(
            width: 200,
            child: images[1],
          ),
          // Container(
          //   width: 200,
          //   child: images[],
          // ),
          for (var result in regulaResults) 
            Text('Regula face match: $result')
        ],
      ),
    );
  }
}
