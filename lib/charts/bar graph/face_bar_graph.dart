import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/results/face_results.dart';
import 'package:laborlink/charts/bar graph/two_bar_data.dart';

class FaceBarGraph extends StatelessWidget {
  const FaceBarGraph({super.key, required this.faceResults});

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
    Map<String, double> count = countResults();

    TwoBarData anomalyBarData = TwoBarData(
        firstAmount: count['passed']!, secondAmount: count['failed']!);

    anomalyBarData.initializeBarData();
    return BarChart(
      BarChartData(
        maxY: 150,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getFaceBottomTiles)),
        ),
        barGroups: anomalyBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: AppColors.secondaryBlue,
                      width: 50,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 150,
                        color: Colors.grey[200],
                      )),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getFaceBottomTiles(double value, TitleMeta meta) {
  Widget text;
  TextStyle style = getTextStyle(
      textColor: AppColors.black,
      fontFamily: AppFonts.poppins,
      fontWeight: AppFontWeights.bold,
      fontSize: 14);

  switch (value.toInt()) {
    case 0:
      text = Text(
        'Passed',
        style: style,
      );
      break;
    case 1:
      text = Text(
        'Failed',
        style: style,
      );
      break;
    default:
      text = const Text('');
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
