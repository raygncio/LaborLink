import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class NoOngoingRequestCard extends StatefulWidget {
  const NoOngoingRequestCard({Key? key}) : super(key: key);

  @override
  State<NoOngoingRequestCard> createState() => _NoOngoingRequestCardState();
}

class _NoOngoingRequestCardState extends State<NoOngoingRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dirtyWhite,
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
                  Text("No ongoing request",
                      style: getTextStyle(
                          textColor: AppColors.grey,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 12)),
                  Text("Make a request today!",
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
