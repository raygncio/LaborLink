import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Admin/ReportGenerationPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/LogoutButton.dart';
import 'package:laborlink/charts/bar graph/anomaly_bar_graph.dart';
import 'package:laborlink/charts/bar graph/face_bar_graph.dart';
import 'package:laborlink/charts/pie%20chart/anomaly_pie_chart.dart';
import 'package:laborlink/charts/pie%20chart/face_pie_chart.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/request.dart';
import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/models/results/face_results.dart';
import 'package:laborlink/styles.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  FaceResults? faceResult;
  AnomalyResults? anomalyResult;
  Request? completedRequest;
  DatabaseService service = DatabaseService();

  List<AnomalyResults> anomalyResults = [];
  List<FaceResults> faceResults = [];
  List<Request> completedRequests = [];

  _loadData() async {
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOADING DATA');
    anomalyResults = await service.getAllAnomalyResults();
    faceResults = await service.getAllFaceResults();
    completedRequests = await service.getAllCompletedRequests();
    setState(() {});
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 9, right: 8, top: 0, bottom: 0),
            height: deviceHeight,
            width: deviceWidth,
            color: AppColors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  generateReportsSection(deviceWidth),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Anomaly Detection',
                    style: getTextStyle(
                        textColor: AppColors.primaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: AnomalyPieChart(
                      anomalyResults: anomalyResults,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Face Verification',
                    style: getTextStyle(
                        textColor: AppColors.primaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: FacePieChart(
                      faceResults: faceResults,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: LogoutButton(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
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
                  textColor: AppColors.primaryBlue,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 18),
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
