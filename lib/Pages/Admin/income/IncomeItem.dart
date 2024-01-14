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
            SizedBox(
              height: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Title: ${result.title[0].toUpperCase()}${result.title.substring(1).toLowerCase()}',
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 8),
                      ),
                      const Spacer(),
                      Text(
                        'User ID: ${result.userId}',
                        style: getTextStyle(
                            textColor: AppColors.grey,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 6),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Request ID: ${result.requestId!}',
                        style: getTextStyle(
                            textColor: AppColors.accentOrange,
                            fontFamily: AppFonts.poppins,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 6),
                      ),
                      const Spacer(),
                      Text(
                        'Handyman ID: ${result.handymanId!}',
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

            const SizedBox(
              height: 4,
            ), // fixed spacing
            Row(
              children: [
                Text(
                  '${result.category[0].toUpperCase()}${result.category.substring(1).toLowerCase()}',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Text(
                  result.suggestedPrice.toString(),
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Text(
                  income.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Text(
                  result.createdAt.toString().substring(0, 16),
                  textAlign: TextAlign.center,
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
