import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class IncomeHeader extends StatelessWidget {
  const IncomeHeader({super.key});

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
