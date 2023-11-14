import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';

class ClientInfoCard extends StatefulWidget {
  final Map<String, dynamic> clientInfo;
  const ClientInfoCard({Key? key, required this.clientInfo}) : super(key: key);

  @override
  State<ClientInfoCard> createState() => ClientInfoCardState();
}

class ClientInfoCardState extends State<ClientInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              color: AppColors.blackShadow,
            ),
          ]),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            SizedBox(
              height: 61,
              width: 61,
              child: ClipOval(
                child: Image.network(widget.clientInfo["img_url"]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.clientInfo['name'],
                      style: getTextStyle(
                          textColor: AppColors.primaryBlue,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        AppBadge(
                            label: widget.clientInfo["area"],
                            type: BadgeType.normal)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: RateWidget(
                        rate: widget.clientInfo["rating"], iconSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
