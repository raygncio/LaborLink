import 'package:laborlink/models/results/face_results.dart';
import 'package:laborlink/Pages/Admin/FaceItem.dart';
import 'package:flutter/material.dart';

class FaceList extends StatelessWidget {
  const FaceList({super.key, required this.results});

  final List<FaceResults> results;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, index) => FaceItem(result: results[index]),
    );
  }
}
