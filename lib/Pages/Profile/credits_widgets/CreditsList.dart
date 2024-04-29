import 'package:laborlink/Pages/Profile/credits_widgets/CreditsItem.dart';
import 'package:laborlink/Pages/Profile/credits_widgets/CreditsHeader.dart';
import 'package:flutter/material.dart';
import 'package:laborlink/models/transaction.dart';

class CreditsList extends StatelessWidget {
  const CreditsList({super.key, required this.transactionHistory});

  final List<Transaction> transactionHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditsHeader(
          transactionHistory: transactionHistory,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: transactionHistory.length,
            itemBuilder: (ctx, index) =>
                CreditsItem(transaction: transactionHistory[index]),
          ),
        ),
      ],
    );
  }
}
