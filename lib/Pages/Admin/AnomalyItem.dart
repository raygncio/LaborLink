import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class AnomalyItem extends StatelessWidget {
  const AnomalyItem({super.key, required this.result});

  final AnomalyResults result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.anomalyResultId!,
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: 8),
            ),
            const SizedBox(
              height: 4,
            ), // fixed spacing
            Row(
              children: [
                Text(
                  result.idType,
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(), // space
                Container(
                  width: 40,
                  child: Image.network(result.attachment),
                ),
                const Spacer(), // space
                Text(
                  result.result,
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
