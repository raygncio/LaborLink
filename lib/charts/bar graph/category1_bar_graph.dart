import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/charts/bar%20graph/five_bar_data.dart';

class Category1BarGraph extends StatelessWidget {
  const Category1BarGraph({super.key, required this.handymenList});

  final List<Handyman> handymenList;

  countCategory() {
    Map<String, double> categoryCount = {
      'plumbing': 0,
      'carpentry': 0,
      'electrical': 0,
      'painting': 0,
      'maintenance': 0,
    };
    int plumbing = 1;
    int carpentry = 1;
    int electrical = 1;
    int painting = 1;
    int maintenance = 1;

    for (var handyman in handymenList) {
      switch (handyman.specialization.toLowerCase()) {
        case 'plumbing':
          plumbing++;
          break;
        case 'carpentry':
          carpentry++;
          break;
        case 'electrical':
          electrical++;
          break;
        case 'painting':
          painting++;
          break;
        case 'maintenance':
          maintenance++;
          break;
      }
    }
    categoryCount['plumbing'] = plumbing.toDouble();
    categoryCount['carpentry'] = carpentry.toDouble();
    categoryCount['electrical'] = electrical.toDouble();
    categoryCount['painting'] = painting.toDouble();
    categoryCount['maintenance'] = maintenance.toDouble();

    return categoryCount;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryCount = countCategory();
    FiveBarData categoryBarData = FiveBarData(
      firstAmount: categoryCount['plumbing']!,
      secondAmount: categoryCount['carpentry']!,
      thirdAmount: categoryCount['electrical']!,
      fourthAmount: categoryCount['painting']!,
      fifthAmount: categoryCount['maintenance']!,
    );

    categoryBarData.initializeBarData();
    return BarChart(
      BarChartData(
        maxY: 20,
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
        barGroups: categoryBarData.barData
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
                        toY: 20,
                        color: Colors.grey[100],
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
      fontSize: 10);

  switch (value.toInt()) {
    case 0:
      text = Text(
        'Plumbing',
        style: style,
      );
      break;
    case 1:
      text = Text(
        'Carpentry',
        style: style,
      );
      break;
    case 2:
      text = Text(
        'Electrical',
        style: style,
      );
      break;
    case 3:
      text = Text(
        'Painting',
        style: style,
      );
      break;
    case 4:
      text = Text(
        'Maintenance',
        style: style,
      );
      break;
    default:
      text = const Text('');
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
