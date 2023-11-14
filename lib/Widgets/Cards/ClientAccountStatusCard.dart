import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/styles.dart';

enum ClientAccountStatus {
  active,
  blocked,
}

class ClientAccountStatusCard extends StatefulWidget {
  final clientInfo;
  final accountStatus;
  const ClientAccountStatusCard(
      {Key? key, required this.clientInfo, required this.accountStatus})
      : super(key: key);

  @override
  State<ClientAccountStatusCard> createState() =>
      _ClientAccountStatusCardState();
}

class _ClientAccountStatusCardState extends State<ClientAccountStatusCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 14, right: 14, top: 6.61, bottom: 8.71),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey)),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      height: 61,
                      width: 61,
                      child: ClipOval(
                        child: Image.network(widget.clientInfo["img_url"]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.85),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.clientInfo["name"],
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: AppBadge(
                                label: "ID: 12345",
                                type: BadgeType.normal,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 1),
                              ),
                            ),
                            AppBadge(
                              label:
                                  widget.accountStatus == ClientAccountStatus.active
                                      ? "Active"
                                      : "Blocked",
                              type:
                                  widget.accountStatus == ClientAccountStatus.active
                                      ? BadgeType.normal
                                      : BadgeType.blocked,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 11, vertical: 1),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: RateWidget(
                              rate: widget.clientInfo["rating"],
                              iconSize: 11),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.89),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double columnWidth = constraints.maxWidth / 2;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: columnWidth,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWithIcon(
                                icon: Icon(Icons.place,
                                    size: 13, color: AppColors.accentOrange),
                                text: "556 Juan Luna Ave.",
                                fontSize: 9,
                                contentPadding: 8,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 6.75),
                                child: TextWithIcon(
                                  icon: Icon(Icons.phone,
                                      size: 13, color: AppColors.accentOrange),
                                  text: "09223595695",
                                  fontSize: 9,
                                  contentPadding: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: columnWidth,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWithIcon(
                                icon: Icon(Icons.email,
                                    size: 13, color: AppColors.accentOrange),
                                text: "HanniPham@gmail.com",
                                fontSize: 9,
                                contentPadding: 8,
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 71,
              child: Row(
                children: [
                  AppFilledButton(
                      height: 20,
                      text: widget.accountStatus == ClientAccountStatus.active
                          ? "Block"
                          : "Activate",
                      fontSize: 9,
                      textColor:
                      widget.accountStatus == ClientAccountStatus.active
                          ? AppColors.black
                          : null,
                      fontFamily: AppFonts.montserrat,
                      color: widget.accountStatus == ClientAccountStatus.active
                          ? AppColors.dirtyWhite
                          : AppColors.secondaryBlue,
                      command:
                      widget.accountStatus == ClientAccountStatus.active
                          ? () {
                        yesCancelDialog(context,
                            "Are you sure you want to block this account?");
                      }
                          : () {
                        yesCancelDialog(context,
                            "Are you sure you want to activate this account?");
                      },
                      borderRadius: 8)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
