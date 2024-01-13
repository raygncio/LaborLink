import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ViewHandymanProposal.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class HandymanProposalCard extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const HandymanProposalCard({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<HandymanProposalCard> createState() => HandymanProposalCardState();
}

class HandymanProposalCardState extends State<HandymanProposalCard> {
  late String fullname;
  File? defaultAvatar;

  @override
  void initState() {
    super.initState();
    // Call an async function to fetch data
    _loadDefaultAvatar();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  _loadDefaultAvatar() async {
    defaultAvatar =
        await getImageFileFromAssets('icons/person-circle-blue.png');
  }

  @override
  Widget build(BuildContext context) {
    // Use null-aware and null-coalescing operators to handle null values
    String firstName =
        capitalizeFirstLetter(widget.handymanInfo["firstName"] ?? '');
    String middleName =
        capitalizeFirstLetter(widget.handymanInfo["middleName"] ?? '');
    String lastName =
        capitalizeFirstLetter(widget.handymanInfo["lastName"] ?? '');
    String suffix = capitalizeFirstLetter(widget.handymanInfo["suffix"] ?? '');

    // Concatenate non-null values
    fullname = '$firstName $middleName $lastName $suffix';

    return Container(
      height: 81,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 61,
                  width: 61,
                  child: ClipOval(
                    child: Image.asset('assets/icons/person-circle-blue.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullname,
                          style: getTextStyle(
                              textColor: AppColors.primaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: AppBadge(
                                  label: capitalizeFirstLetter(
                                      widget.handymanInfo["specialization"] ??
                                          ''),
                                  type: BadgeType.normal),
                            ),
                            AppBadge(
                                label: capitalizeFirstLetter(
                                    widget.handymanInfo["city"] ?? ''),
                                type: BadgeType.normal)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: RateWidget(
                            rate: (widget.handymanInfo["rates"] ?? 0).toInt(),
                            iconSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 18,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppBadge(
                    label: "Offered ₱ " +
                            widget.handymanInfo["bidPrice"].toString() ??
                        '',
                    type: BadgeType.offer,
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  ),
                  SizedBox(
                    width: 85,
                    child: Row(
                      children: [
                        AppFilledButton(
                            padding: const EdgeInsets.only(top: 6),
                            height: 20,
                            text: "View Proposal",
                            fontSize: 9,
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.secondaryBlue,
                            command: onViewProposal,
                            borderRadius: 8),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onViewProposal() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ViewHandymanProposal(handymanInfo: widget.handymanInfo),
    ));
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
