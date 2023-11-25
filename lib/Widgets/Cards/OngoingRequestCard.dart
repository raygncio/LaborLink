import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class OngoingRequestCard extends StatefulWidget {
  final String title;
  final String address;
  final String? imgUrl;
  const OngoingRequestCard(
      {Key? key, required this.title, required this.address, this.imgUrl})
      : super(key: key);

  @override
  State<OngoingRequestCard> createState() => _OngoingRequestCardState();
}

class _OngoingRequestCardState extends State<OngoingRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: AppColors.dirtyWhite,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.orangeCard,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, right: 12, top: 5, bottom: 7),
          child: Row(
            children: [
              Image.asset("assets/icons/activity-ongoing-orange.png",
                  height: 28, width: 27),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                              textColor: AppColors.accentOrange,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 12)),
                      Text(widget.address,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                              textColor: AppColors.accentOrange,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.medium,
                              fontSize: 7))
                    ],
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(2),
              //   decoration: const BoxDecoration(
              //       color: AppColors.accentOrange, shape: BoxShape.circle),
              //   child: ClipOval(
              //     child: Image.network(
              //       widget.imgUrl ?? "",
              //       width: 30,
              //       height: 30,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
