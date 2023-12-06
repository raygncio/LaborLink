import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextWithIcon.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/report.dart';
import 'package:laborlink/models/client.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/providers/current_user_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

// class IssuesReportedPage extends StatefulWidget {
//   final String userId;
//   const IssuesReportedPage({Key? key, required this.userId}) : super(key: key);

//   @override
//   State<IssuesReportedPage> createState() => _IssuesReportedPageState();
// }

class IssuesReportedPage extends ConsumerWidget {
  List<Report> issues = []; // This will hold your list of issues
  String fullName = "";
  File? defaultAvatar;
  final formattedDate = DateFormat('yyyy-MM-dd hh:mm');

  // @override
  // void initState() {
  //   super.initState();
  //   // Call an async function to fetch data
  //   _loadData();
  //   fetchUserData();
  //   _loadDefaultAvatar();
  // }

  // Define an async function to fetch data
  _loadData(String userId) async {
    // Use await to wait for the result
    // need ko ata i connect yung user id ng client sa user id ng reports?
    List<Report> reports = await getAllReportData(userId);
    issues = reports;
  }

  // Future<void> fetchUserData() async {
  //   DatabaseService service = DatabaseService();
  //   try {
  //     Client clientInfo = await service.getUserData("test");

  //     fullName = clientInfo.firstName +
  //         ' ' +
  //         (clientInfo.middleName ?? "") +
  //         ' ' +
  //         clientInfo.lastName +
  //         ' ' +
  //         (clientInfo.suffix ?? "");
  //   } catch (error) {
  //     print('Error fetching user data: $error');
  //   }
  // }

  Future<List<Report>> getAllReportData(String userId) async {
    DatabaseService service = DatabaseService();
    try {
      List<Report> reports = await service.getAllReportData("test");
      return reports;
    } catch (error) {
      print('Error fetching user data 2: $error');
      // Return an empty list in case of an error
      return [];
    }
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
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(currentUserProvider.notifier).saveCurrentUserInfo();

    Map<String, dynamic> userInfo = ref.watch(currentUserProvider);
    String? userId = userInfo['userId'];
    String? fullName = userInfo['firstName'] +
        ' ' +
        (userInfo['middleName'] ?? "") +
        ' ' +
        userInfo['lastName'] +
        ' ' +
        (userInfo['suffix'] ?? "");
    _loadData(userId ?? '');
    // fetchUserData();
    _loadDefaultAvatar();
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: Container(
          width: deviceWidth,
          color: AppColors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 74),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        issues.length, // Use the length of the issues list
                    itemBuilder: (context, index) {
                      Report report =
                          issues[index]; // Get the report at the current index

                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                                color: AppColors.secondaryBlue, width: 0.5),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.64, bottom: 12),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: CircleAvatar(
                                            radius: 27,
                                            backgroundColor: AppColors.white,
                                            foregroundImage:
                                                FileImage(defaultAvatar!),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fullName ?? '',
                                              style: getTextStyle(
                                                  textColor:
                                                      AppColors.secondaryBlue,
                                                  fontFamily:
                                                      AppFonts.montserrat,
                                                  fontWeight:
                                                      AppFontWeights.bold,
                                                  fontSize: 15),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.82),
                                              child: Text(
                                                formattedDate
                                                    .format(report.createdAt!),
                                                style: getTextStyle(
                                                    textColor: AppColors.black,
                                                    fontFamily:
                                                        AppFonts.montserrat,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.82),
                                              child: AppBadge(
                                                label:
                                                    "Request ID: ${report.reportId}", // Use report data
                                                type: BadgeType.normal,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Image.network(report.proof),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      report.issue, // Use report data
                                      overflow: TextOverflow.visible,
                                      style: getTextStyle(
                                          textColor: AppColors.black,
                                          fontFamily: AppFonts.montserrat,
                                          fontWeight: AppFontWeights.regular,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 17,
                              child: reportBadge("Waiting"),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
              Align(
                  alignment: Alignment.topCenter,
                  child: appBar(deviceWidth, context)),
            ],
          ),
        ),
      ),
    );
  }

  void onBack(BuildContext context) => Navigator.of(context).pop();

  Widget appBar(deviceWidth, context) => Container(
        color: AppColors.secondaryBlue,
        height: 74,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SizedBox(
              height: 23,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: () => onBack(context),
                        child: Image.asset("assets/icons/back-btn-2.png",
                            height: 23,
                            width: 13,
                            alignment: Alignment.centerLeft),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Issues Reported",
                      style: getTextStyle(
                          textColor: AppColors.secondaryYellow,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget reportBadge(String status) {
    Color? bgColor;
    if (status == "Waiting") {
      bgColor = AppColors.secondaryBlue;
    } else if (status == "Resolved") {
      bgColor = AppColors.green;
    } else if (status == "Approved") {
      bgColor = AppColors.accentOrange;
    } else {
      bgColor = AppColors.dirtyWhite;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 88,
          height: 25,
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(status,
                style: getTextStyle(
                    textColor: status == "Returned"
                        ? AppColors.black
                        : AppColors.white,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 12)),
          ),
        ),
        Visibility(
          visible: status == "Approved",
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: SizedBox(
              width: 119,
              child: Text(
                  "Expect a customer representative to call you within the days",
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.right,
                  style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.regular,
                      fontSize: 7)),
            ),
          ),
        )
      ],
    );
  }
}
