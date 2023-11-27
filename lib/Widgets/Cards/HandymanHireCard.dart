import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class HandymanHireCard extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const HandymanHireCard({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<HandymanHireCard> createState() => HandymanHireCardState();
}

class HandymanHireCardState extends State<HandymanHireCard> {
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
    String firstName = widget.handymanInfo['firstName'] ?? '';
    String middleName = widget.handymanInfo['middleName'] ?? '';
    String lastName = widget.handymanInfo['lastName'] ?? '';
    String suffix = widget.handymanInfo['suffix'] ?? '';

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
                    child: Image.file(defaultAvatar!),
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
                                  label: widget.handymanInfo["specialization"],
                                  type: BadgeType.normal),
                            ),
                            AppBadge(
                                label: widget.handymanInfo["city"],
                                type: BadgeType.normal)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: RateWidget(
                            rate: widget.handymanInfo["rating"], iconSize: 12),
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
                  const AppBadge(
                    label: "Accepts offer ",
                    type: BadgeType.inProgress,
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  ),
                  SizedBox(
                    width: 48,
                    child: Row(
                      children: [
                        AppFilledButton(
                            padding: const EdgeInsets.only(top: 5),
                            height: 20,
                            text: "Hire",
                            fontSize: 9,
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.accentOrange,
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
    // need to hire the handyman
  }
}
