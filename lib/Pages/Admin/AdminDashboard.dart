import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Admin/ReportGenerationPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/LogoutButton.dart';
import 'package:laborlink/charts/bar%20graph/category1_bar_graph.dart';
import 'package:laborlink/charts/bar%20graph/category2_bar_graph.dart';
import 'package:laborlink/charts/pie%20chart/anomaly_pie_chart.dart';
import 'package:laborlink/charts/pie%20chart/client_handyman_pie_chart.dart';
import 'package:laborlink/charts/pie%20chart/face_pie_chart.dart';
import 'package:laborlink/charts/pie%20chart/request_pie_chart.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/models/handyman_approval.dart';
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

  // non-reports
  List<Client> usersList = [];
  List<Handyman> handymenList = [];
  List<Request> allRequestsList = [];
  List<HandymanApproval> allApprovalsList = [];

  _loadData() async {
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOADING DATA');
    anomalyResults = await service.getAllAnomalyResults();
    faceResults = await service.getAllFaceResults();
    completedRequests = await service.getAllCompletedRequests();

    // non-reports
    usersList = await service.getAllClientHandyman();
    handymenList = await service.getAllHandyman();
    allRequestsList = await service.getAllRequests();
    allApprovalsList = await service.getAllApprovals();

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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Users',
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
                    child: ClientHandymanPieChart(
                      usersList: usersList,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Requests',
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
                    child: RequestPieChart(
                      requestsList: allRequestsList,
                      approvalsList: allApprovalsList,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Categories',
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
                    child: Category1BarGraph(
                      handymenList: handymenList,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 200,
                    child: Category2BarGraph(
                      handymenList: handymenList,
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
