import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:laborlink/models/results/face_results.dart';
import 'package:laborlink/styles.dart';

class FacePieChart extends StatelessWidget {
  const FacePieChart({super.key, required this.faceResults});

  final List<FaceResults> faceResults;

  countResults() {
    Map<String, double> count = {'passed': 0, 'failed': 0};
    int passedCount = 0;
    int failedCount = 0;
    for (var result in faceResults) {
      if (result.result == '0.00') {
        failedCount++;
        continue;
      }
      if (result.result2 != null) {
        if (result.result == '0.00' || result.result2 == '0.00') {
          failedCount++;
          continue;
        }
      }
      passedCount++;
    }
    count['passed'] = passedCount.toDouble();
    count['failed'] = failedCount.toDouble();
    return count;
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
              "Passed",
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 12),
            ),
            Text(
              "Failed",
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
                value: countResults()["failed"],
                title: countResults()["failed"].toInt().toString(),
                titleStyle: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 12),
                color: AppColors.dirtyWhite,
              ),
              // item 1
              PieChartSectionData(
                value: countResults()["passed"],
                title: countResults()["passed"].toInt().toString(),
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
