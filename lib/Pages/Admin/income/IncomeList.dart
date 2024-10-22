import 'package:laborlink/models/request.dart';
import 'package:laborlink/Pages/Admin/income/IncomeItem.dart';
import 'package:laborlink/Pages/Admin/income/IncomeHeader.dart';
import 'package:flutter/material.dart';

class IncomeList extends StatelessWidget {
  const IncomeList({super.key, required this.results});

  final List<Request> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IncomeHeader(
          completedRequests: results,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (ctx, index) => IncomeItem(result: results[index]),
          ),
        ),
      ],
    );
  }
}
