import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/charts/bar graph/two_bar_data.dart';

class AnomalyBarGraph extends StatelessWidget {
  const AnomalyBarGraph({super.key, required this.anomalyResults});

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
    TwoBarData anomalyBarData =
        TwoBarData(firstAmount: countNoAnomaly(), secondAmount: countAnomaly());

    anomalyBarData.initializeBarData();
    return BarChart(
      BarChartData(
        maxY: 100,
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
                  showTitles: true, getTitlesWidget: getAnomalyBottomTiles)),
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
                        toY: 100,
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

Widget getAnomalyBottomTiles(double value, TitleMeta meta) {
  Widget text;
  TextStyle style = getTextStyle(
      textColor: AppColors.black,
      fontFamily: AppFonts.poppins,
      fontWeight: AppFontWeights.bold,
      fontSize: 14);

  switch (value.toInt()) {
    case 0:
      text = Text(
        'No Anomalies',
        style: style,
      );
      break;
    case 1:
      text = Text(
        'Anomalies',
        style: style,
      );
      break;
    default:
      text = const Text('');
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
