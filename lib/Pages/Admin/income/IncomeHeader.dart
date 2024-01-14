import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/request.dart';

class IncomeHeader extends StatelessWidget {
  const IncomeHeader({super.key, required this.completedRequests});

  final List<Request> completedRequests;

  double getTotalAcquired() {
    double total = 0.0;
    for (var request in completedRequests) {
      total += request.suggestedPrice;
    }
    return total;
  }

  double getTotalIncome() {
    double total = 0.0;
    double origPrice = 0.0;
    double newPrice = 0.0;
    for (var request in completedRequests) {
      newPrice = request.suggestedPrice;
      origPrice = newPrice / 1.10;
      total += newPrice - origPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Total Acquired',
                  textAlign: TextAlign.start,
                  style: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 15),
                ),
                const Spacer(),
                Text(
                  'PHP ${getTotalAcquired().toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.extraBold,
                      fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Total Income',
                  textAlign: TextAlign.start,
                  style: getTextStyle(
                      textColor: AppColors.secondaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 15),
                ),
                const Spacer(),
                Text(
                  'PHP ${getTotalIncome().toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.primaryBlue,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.extraBold,
                      fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Category',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 8),
                ),
                const Spacer(),
                Text(
                  'Price',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 8),
                ),
                const Spacer(),
                Text(
                  'Gain',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 8),
                ),
                const Spacer(),
                Text(
                  'Created At',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.bold,
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
