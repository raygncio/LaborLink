import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class HandymanInfoCard extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const HandymanInfoCard({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<HandymanInfoCard> createState() => HandymanInfoCardState();
}

class HandymanInfoCardState extends State<HandymanInfoCard> {
  late String fullname;
  File? defaultAvatar;

  @override
  void initState() {
    initializeFullname();
    super.initState();
    // Call an async function to fetch data
    _loadDefaultAvatar();
  }

  void initializeFullname() {
    String firstName = widget.handymanInfo['firstName'] ?? '';
    String middleName = widget.handymanInfo['middleName'] ?? '';
    String lastName = widget.handymanInfo['lastName'] ?? '';
    String suffix = widget.handymanInfo['suffix'] ?? '';

    fullname = '$firstName $middleName $lastName $suffix';
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
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
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
              height: 45,
              width: 45,
              child: CircleAvatar(
                backgroundColor: AppColors.white,
                child: ClipOval(
                    child: Image.asset('assets/icons/person-circle-blue.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullname,
                    style: getTextStyle(
                        textColor: AppColors.primaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: AppBadge(
                              label:
                                  widget.handymanInfo["specialization"] ?? '',
                              type: BadgeType.normal),
                        ),
                        AppBadge(
                            label: widget.handymanInfo["city"] ?? '',
                            type: BadgeType.normal)
                      ],
                    ),
                  ),
                  // *************** RATINGS
                  // static ratings
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: RatingBar.builder(
                        initialRating: 3, // input
                        itemCount: 5,
                        itemSize: 15,
                        ignoreGestures: true,
                        itemBuilder: (ctx, index) => const Icon(
                              Icons.star,
                              color: AppColors.secondaryYellow,
                            ),
                        onRatingUpdate: (rating) {}),
                  )
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.dirtyWhite,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset(
                  "assets/icons/${widget.handymanInfo['specialization'].toString().toLowerCase()}.png",
                  width: 50,
                  height: 48),
            ),
          ],
        ),
      ),
    );
  }
}
