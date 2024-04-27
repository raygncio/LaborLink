import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/charts/bar%20graph/five_bar_data.dart';

class Category2BarGraph extends StatelessWidget {
  const Category2BarGraph({super.key, required this.handymenList});

  final List<Handyman> handymenList;

  countCategory() {
    Map<String, double> categoryCount = {
      'welding': 0,
      'housekeeping': 0,
      'roofing': 0,
      'installation': 0,
      'pestcontrol': 0
    };
    int welding = 1;
    int housekeeping = 1;
    int roofing = 1;
    int installation = 1;
    int pestcontrol = 1;

    for (var handyman in handymenList) {
      switch (handyman.specialization.toLowerCase()) {
        case 'welding':
          welding++;
          break;
        case 'housekeeping':
          housekeeping++;
          break;
        case 'roofing':
          roofing++;
          break;
        case 'installations':
          installation++;
          break;
        case 'pestcontrol':
          pestcontrol++;
          break;
      }
    }
    categoryCount['welding'] = welding.toDouble();
    categoryCount['housekeeping'] = housekeeping.toDouble();
    categoryCount['roofing'] = roofing.toDouble();
    categoryCount['installation'] = installation.toDouble();
    categoryCount['pestcontrol'] = pestcontrol.toDouble();

    return categoryCount;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryCount = countCategory();
    FiveBarData categoryBarData = FiveBarData(
      firstAmount: categoryCount['welding']!,
      secondAmount: categoryCount['housekeeping']!,
      thirdAmount: categoryCount['roofing']!,
      fourthAmount: categoryCount['installation']!,
      fifthAmount: categoryCount['pestcontrol']!,
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
        'Welding',
        style: style,
      );
      break;
    case 1:
      text = Text(
        'Housekeeping',
        style: style,
      );
      break;
    case 2:
      text = Text(
        'Roofing',
        style: style,
      );
      break;
    case 3:
      text = Text(
        'Installations',
        style: style,
      );
      break;
    case 4:
      text = Text(
        'Pest Control',
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
