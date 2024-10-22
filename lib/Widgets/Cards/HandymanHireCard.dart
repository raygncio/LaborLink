import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:laborlink/models/database_service.dart';

class HandymanHireCard extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  final String requestId;
  const HandymanHireCard(
      {Key? key, required this.handymanInfo, required this.requestId})
      : super(key: key);

  @override
  State<HandymanHireCard> createState() => HandymanHireCardState();
}

class HandymanHireCardState extends State<HandymanHireCard> {
  late String fullname;
  File? defaultAvatar;
  final DatabaseService service = DatabaseService();

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
    // print("*************************CHECK THE FULL NAME $fullname");
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
                                  label:
                                      widget.handymanInfo["specialization"] ??
                                          '',
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
                            command: hireHandyman,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Hiring'),
          content: const Text('Are you sure you want to hire this handyman?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform action on 'No' button press
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform action on 'Yes' button press
                hireHandyman();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void hireHandyman() async {
    // hire the handyman
    // update handyman approval status to approved
    // assign the handyman id to the request
    // update the request progress to hired
    bool confirmHire = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hire Handyman'),
              content: const Text('Are you sure you want to hire this handyman?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false when cancel is pressed
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true when confirm is pressed
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmHire == true) {
      // print(widget.handymanInfo['userId']);
      // print(widget.handymanInfo['activeRequestId']);
      // print(widget.requestId);
      // print(widget.handymanInfo['handymanId']);
      try {
        await service.hiredHandyman(widget.handymanInfo['userId'],
            widget.handymanInfo['activeRequestId']);
        await service.updateRequestProgress(
            widget.handymanInfo['activeRequestId'],
            widget.handymanInfo['handymanId']);

        // print('Document updated successfully');
        // Show SnackBar when request is successfully cancelled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Handyman hired successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.tertiaryBlue,
          ),
        );
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClientMainPage(userId: widget.requestId),
        ));
      } catch (e) {
        // print('Error updating document: $e');
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating document."),
          backgroundColor: Colors.red,
        ),
      );
      }
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
