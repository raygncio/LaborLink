import 'package:flutter/material.dart';
import 'package:laborlink/models/transaction.dart';
import 'package:laborlink/styles.dart';

class CreditsItem extends StatelessWidget {
  const CreditsItem({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        transaction.transactionId!,
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 8),
                      ),
                      const Spacer(),
                      Text(
                        transaction.amount,
                        style: getTextStyle(
                            textColor: AppColors.grey,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 6),
                      ),
                      const Spacer(),
                      Text(
                        transaction.description,
                        style: getTextStyle(
                            textColor: AppColors.grey,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 6),
                      ),
                      const Spacer(),
                      Text(
                        transaction.createdAt.toString(),
                        style: getTextStyle(
                            textColor: AppColors.grey,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
