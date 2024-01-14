import 'package:laborlink/models/request.dart';
import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class IncomeItem extends StatelessWidget {
  const IncomeItem({super.key, required this.result});

  final Request result;

  @override
  Widget build(BuildContext context) {
    double newPrice = result.suggestedPrice;
    double origPrice = 0.0;
    double income = 0.0;

    origPrice = newPrice / (1 + 0.10);
    income = newPrice - origPrice;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Request ID: ${result.requestId!}',
                  style: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                Text(
                  'User ID: ${result.userId}',
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                Text(
                  'Handyman ID: ${result.handymanId!}',
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
              ],
            ),

            const SizedBox(
              height: 4,
            ), // fixed spacing
            Row(
              children: [
                Text(
                  result.title,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(),
                Text(
                  result.category,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Text(
                  result.progress,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Text(
                  result.suggestedPrice.toString(),
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Text(
                  income.toString(),
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Text(
                  result.createdAt.toString(),
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
