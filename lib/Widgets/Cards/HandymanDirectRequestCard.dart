import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Home/ClientHomePage.dart';
import 'package:laborlink/Pages/Client/Home/DirectRequestFormPage.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:laborlink/models/request.dart';
import 'dart:io';

class HandymanDirectRequestCard extends StatefulWidget {
  final Function(String) submitRequest;
  final Map<String, dynamic> handymanInfo;
  final String userId;
  const HandymanDirectRequestCard(
      {Key? key,
      required this.handymanInfo,
      required this.submitRequest,
      required this.userId})
      : super(key: key);

  @override
  State<HandymanDirectRequestCard> createState() =>
      _HandymanDirectRequestCardState();
}

class _HandymanDirectRequestCardState extends State<HandymanDirectRequestCard> {
  late String fullname;
  File? defaultAvatar;
  bool _hasPendingOrOngoingRequest = false;

  // Function to check if there is any pending or ongoing request
  Future<void> checkPendingOrOngoingRequest() async {
    Request? requestInfo = await service.getRequestsData(widget.userId);
    setState(() {
      _hasPendingOrOngoingRequest = requestInfo != null;
    });
  }

  @override
  void initState() {
    super.initState();
    // Call an async function to fetch data
    checkPendingOrOngoingRequest();
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, right: 10, top: 10, bottom: 10),
          child: Row(
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
                  mainAxisSize: MainAxisSize.min,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: RateWidget(
                          rate: (widget.handymanInfo["rates"] ?? 0).toInt(),
                          iconSize: 12),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 85,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        AppFilledButton(
                            fontSize: 9,
                            height: 20,
                            fontFamily: AppFonts.montserrat,
                            text: "Direct Request",
                            color: AppColors.accentOrange,
                            command: onDirectRequest,
                            borderRadius: 8),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 71,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        AppFilledButton(
                            padding: const EdgeInsets.only(top: 4),
                            fontSize: 9,
                            height: 20,
                            fontFamily: AppFonts.montserrat,
                            text: "View Profile",
                            color: AppColors.secondaryBlue,
                            command: onViewProfile,
                            borderRadius: 8),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDirectRequest() {
    // Check if there are pending or ongoing requests
    if (_hasPendingOrOngoingRequest) {
      // Provide feedback to the user that the request cannot be made
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You cannot make another request while you have a pending or ongoing request."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Allow the user to proceed with the request
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => DirectRequestFormPage(
                handymanInfo: widget.handymanInfo, userId: widget.userId),
          ))
          .then((value) {
        if (value == null) return;

        if (value == "submit") {
          widget.submitRequest("direct");
        }
      });
    }
  }

  void onViewProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ViewHandymanProfile(handymanInfo: widget.handymanInfo),
    ));
  }
}
