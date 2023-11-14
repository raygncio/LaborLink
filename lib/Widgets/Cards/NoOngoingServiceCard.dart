import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class NoOngoingServiceCard extends StatefulWidget {
  const NoOngoingServiceCard({Key? key}) : super(key: key);

  @override
  State<NoOngoingServiceCard> createState() => _NoOngoingServiceCardState();
}

class _NoOngoingServiceCardState extends State<NoOngoingServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 13, right: 14, top: 9, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/icons/activity-gray.png",
                height: 27, width: 26.04),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No ongoing service",
                      style: getTextStyle(
                          textColor: AppColors.grey,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 12)),
                  Text("Look for one today!",
                      style: getTextStyle(
                          textColor: AppColors.grey,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: 7))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
