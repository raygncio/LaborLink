import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/styles.dart';

class AnomalyPieChart extends StatelessWidget {
  const AnomalyPieChart({super.key, required this.anomalyResults});

  final List<AnomalyResults> anomalyResults;

  countAnomaly() {
    int count = 0;
    for (var result in anomalyResults) {
      if (result.result == 'hasanomaly') {
        count++;
      }
    }
    return count.toDouble();
  }

  countNoAnomaly() {
    int count = 0;
    for (var result in anomalyResults) {
      if (result.result == 'noanomaly') {
        count++;
      }
    }
    return count.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Anomalies",
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 12),
            ),
            Text(
              "Anomalies",
              style: getTextStyle(
                  textColor: AppColors.grey,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 12),
            ),
          ],
        ),
        PieChart(
          swapAnimationDuration: const Duration(milliseconds: 750),
          swapAnimationCurve: Curves.easeInOutQuint,
          PieChartData(
            sectionsSpace: 10,
            sections: [
              // item 1
              PieChartSectionData(
                value: countAnomaly(),
                title: countAnomaly().toInt().toString(),
                titleStyle: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 12),
                color: AppColors.dirtyWhite,
              ),
              // item 1
              PieChartSectionData(
                value: countNoAnomaly(),
                title: countNoAnomaly().toInt().toString(),
                titleStyle: getTextStyle(
                    textColor: AppColors.white,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 12),
                color: AppColors.secondaryBlue,
              ),
            ],
          ),
        )
      ],
    );
  }
}
