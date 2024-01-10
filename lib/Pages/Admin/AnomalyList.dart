import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/Pages/Admin/AnomalyItem.dart';
import 'package:flutter/material.dart';

class AnomalyList extends StatelessWidget {
  const AnomalyList({super.key, required this.results});

  final List<AnomalyResults> results;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, index) => AnomalyItem(result: results[index]),
    );
  }
}
