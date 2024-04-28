import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/handyman_approval.dart';
import 'package:laborlink/models/request.dart';
import 'package:laborlink/styles.dart';

class RequestPieChart extends StatelessWidget {
  const RequestPieChart({
    super.key,
    required this.requestsList,
    required this.approvalsList,
  });

  final List<Request> requestsList;
  final List<HandymanApproval> approvalsList;

  countRequests() {
    int count = 0;

    for (var request in requestsList) {
      if (request.progress.toLowerCase() != 'cancelled') {
        count++;
      }
    }
    return count.toDouble();
  }

  countDirectApprovals() {
    int count = 0;
    for (var approval in approvalsList) {
      if (approval.status.toLowerCase() == 'direct') {
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
              "Open",
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 12),
            ),
            Text(
              "Direct",
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
                value: countDirectApprovals(),
                title: countDirectApprovals().toInt().toString(),
                titleStyle: getTextStyle(
                    textColor: AppColors.white,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 12),
                color: AppColors.accentOrange,
              ),
              // item 1
              PieChartSectionData(
                value: countRequests() - countDirectApprovals(),
                title: (countRequests() - countDirectApprovals())
                    .toInt()
                    .toString(),
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
