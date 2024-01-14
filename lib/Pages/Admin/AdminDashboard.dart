import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Admin/ReportGenerationPage.dart';
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
                height: 50,
                width: 300,
                child: Row(
                  children: [
                    AppFilledButton(
                        text: "Face Verification Report",
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: SizedBox(
                height: 50,
                width: 300,
                child: Row(
                  children: [
                    AppFilledButton(
                        text: "Anomaly Detection Report",
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
                height: 50,
                width: 300,
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
                                  reportType: ReportType.income),
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
