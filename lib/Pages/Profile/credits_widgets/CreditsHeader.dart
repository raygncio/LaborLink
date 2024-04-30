import 'package:flutter/material.dart';
import 'package:laborlink/models/transaction.dart';
import 'package:laborlink/styles.dart';

class CreditsHeader extends StatelessWidget {
  const CreditsHeader({super.key, required this.transactionHistory});

  final List<Transaction> transactionHistory;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'ID',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Amount',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Desc',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Created At',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
