import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/styles.dart';

class ClientHandymanPieChart extends StatelessWidget {
  const ClientHandymanPieChart({super.key, required this.usersList});

  final List<Client> usersList;

  countClient() {
    int client = 0;

    for (var user in usersList) {
      if (user.userRole.toLowerCase() == 'client') {
        client++;
      }

    }
    return client.toDouble();
  }

  countHandyman() {
    int handyman = 0;
    for (var user in usersList) {
      if (user.userRole.toLowerCase() == 'handyman') {
        handyman++;
      }
    }
    return handyman.toDouble();
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
              "Client",
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 12),
            ),
            Text(
              "Handyman",
              style: getTextStyle(
                  textColor: AppColors.accentOrange,
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
                value: countHandyman(),
                title: countHandyman().toInt().toString(),
                titleStyle: getTextStyle(
                    textColor: AppColors.white,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 12),
                color: AppColors.accentOrange,
              ),
              // item 1
              PieChartSectionData(
                value: countClient(),
                title: countClient().toInt().toString(),
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
