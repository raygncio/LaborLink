import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Admin/copy/ApprovedIssuesPage.dart';
import 'package:laborlink/Pages/Admin/copy/IssuesForApprovalPage.dart';
import 'package:laborlink/Pages/Admin/copy/ManageClientsAccounts.dart';
import 'package:laborlink/Pages/Admin/copy/ManageHandymanAccounts.dart';
import 'package:laborlink/Pages/Admin/ReportGenerationPage.dart';
import 'package:laborlink/Pages/Admin/copy/ReviewedIssuePage.dart';
import 'package:laborlink/Pages/Admin/copy/RequestsForApprovalPage.dart';
import 'package:laborlink/Pages/Admin/copy/ReviewedRequestsPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/LogoutButton.dart';
import 'package:laborlink/styles.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 65),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 9, right: 8, top: 19, bottom: 28),
              height: deviceHeight,
              width: deviceWidth,
              color: AppColors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    manageAccountsSection(deviceWidth),
                    manageRequestsSection(deviceWidth),
                    manageReportedIssuesSection(deviceWidth),
                    generateReportsSection(deviceWidth),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: LogoutButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          header(),
        ],
      )),
    );
  }

  Widget header() => Container(
        color: AppColors.secondaryBlue,
        height: 65,
        child: Center(
          child: Text("Admin Dashboard",
              style: getTextStyle(
                  textColor: AppColors.secondaryYellow,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 24)),
        ),
      );

  Widget manageAccountsSection(deviceWidth) => Container(
        padding: const EdgeInsets.only(left: 9, right: 13, top: 5, bottom: 10),
        width: deviceWidth,
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manage Accounts",
              style: getTextStyle(
                  textColor: AppColors.white,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ManageClientsAccounts(),
                )),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  height: 29,
                  decoration: BoxDecoration(
                      color: AppColors.blueBadge,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Clients",
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15),
                      ),
                      Text(
                        "100",
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ManageHandymanAccounts(),
                )),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  height: 29,
                  decoration: BoxDecoration(
                      color: AppColors.blueBadge,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Handymen",
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15),
                      ),
                      Text(
                        "100",
                        style: getTextStyle(
                            textColor: AppColors.secondaryBlue,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget manageRequestsSection(deviceWidth) => Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Container(
          padding:
              const EdgeInsets.only(left: 9, right: 13, top: 7, bottom: 10),
          width: deviceWidth,
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manage Requests",
                style: getTextStyle(
                    textColor: AppColors.white,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RequestsForApprovalPage(),
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    height: 29,
                    decoration: BoxDecoration(
                        color: AppColors.blueBadge,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Requests for Approval",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        Text(
                          "5",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReviewedRequestsPage(),
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    height: 29,
                    decoration: BoxDecoration(
                        color: AppColors.blueBadge,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reviewed Requests",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        Text(
                          "78",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget manageReportedIssuesSection(deviceWidth) => Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Container(
          padding:
              const EdgeInsets.only(left: 9, right: 13, top: 7, bottom: 10),
          width: deviceWidth,
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manage Reported Issues",
                style: getTextStyle(
                    textColor: AppColors.white,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const IssuesForApprovalPage(),
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    height: 29,
                    decoration: BoxDecoration(
                        color: AppColors.blueBadge,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Issues for Approval",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        Text(
                          "2",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ApprovedIssuesPage(),
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    height: 29,
                    decoration: BoxDecoration(
                        color: AppColors.blueBadge,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Approved Issues",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        Text(
                          "7",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReviewedIssuePage(),
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    height: 29,
                    decoration: BoxDecoration(
                        color: AppColors.blueBadge,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reviewed Issues",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                        Text(
                          "7",
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget generateReportsSection(deviceWidth) => Padding(
        padding: const EdgeInsets.only(top: 31),
        child: Column(
          children: [
            Text(
              "Generate Reports",
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SizedBox(
                height: 29,
                child: Row(
                  children: [
                    AppFilledButton(
                        text: "Fake Detection Report",
                        fontSize: 15,
                        fontFamily: AppFonts.montserrat,
                        color: AppColors.secondaryBlue,
                        command: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ReportGenerationPage(
                                  reportType: ReportType.anomalyDetection),
                            )),
                        borderRadius: 8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: SizedBox(
                height: 29,
                child: Row(
                  children: [
                    AppFilledButton(
                        text: "Income Report",
                        fontSize: 15,
                        fontFamily: AppFonts.montserrat,
                        color: AppColors.secondaryBlue,
                        command: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ReportGenerationPage(
                                  reportType: ReportType.faceVerification),
                            )),
                        borderRadius: 8),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
