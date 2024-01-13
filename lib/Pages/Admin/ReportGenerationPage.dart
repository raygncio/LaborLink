import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laborlink/Pages/Admin/face/FaceList.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/Pages/Admin/anomaly/AnomalyList.dart';
import 'package:laborlink/Pages/Admin/pdf_service.dart';
import 'package:laborlink/models/results/face_results.dart';
import 'package:laborlink/styles.dart';

enum ReportType { faceVerification, anomalyDetection }

class ReportGenerationPage extends StatefulWidget {
  final dynamic reportType;

  const ReportGenerationPage({Key? key, required this.reportType})
      : super(key: key);

  @override
  State<ReportGenerationPage> createState() => _ReportGenerationPageState();
}

class _ReportGenerationPageState extends State<ReportGenerationPage> {
  FaceResults? faceResult;
  AnomalyResults? anomalyResult;
  DatabaseService service = DatabaseService();
  PdfInvoiceService pdfService = PdfInvoiceService();

  List<AnomalyResults> anomalyResults = [];
  List<FaceResults> faceResults = [];

  _loadData() async {
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOADING DATA');
    anomalyResults = await service.getAllAnomalyResults();
    faceResults = await service.getAllFaceResults();
    print(faceResults);
    setState(() {});
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceWidth = MediaQuery.of(context).size.width;
    // final deviceHeight = MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text('No data found!'),
    );

    if (widget.reportType == ReportType.anomalyDetection &&
        anomalyResults.isNotEmpty) {
      mainContent = AnomalyList(results: anomalyResults);
    }

    if (widget.reportType == ReportType.faceVerification &&
        faceResults.isNotEmpty) {
      mainContent = FaceList(results: faceResults);
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
          child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            appBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 15, top: 22),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: mainContent,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                AppFilledButton(
                    padding: const EdgeInsets.only(
                        left: 25, right: 23, bottom: 21, top: 28),
                    height: 42,
                    text: "Download PDF",
                    fontSize: 18,
                    fontFamily: AppFonts.poppins,
                    color: AppColors.accentOrange,
                    command: () async {
                      if (widget.reportType == ReportType.anomalyDetection) {
                        final data = await pdfService
                            .createAnomalyReport(anomalyResults);
                        String download = await pdfService.savePdfFile(
                            'anomaly_detection_${DateTime.now()}', data);
                        if (download == 'Success') {
                          Fluttertoast.showToast(
                              msg: "Saved to downloads",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 12.0);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                download,
                                style: const TextStyle(color: AppColors.white),
                              ),
                              backgroundColor: AppColors.red,
                            ),
                          );
                        }
                      }
                    },
                    borderRadius: 5),
              ],
            )
          ],
        ),
      )),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar() => Container(
        color: AppColors.secondaryBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 14),
                child: GestureDetector(
                  onTap: onBack,
                  child: Image.asset(
                    "assets/icons/back-btn-2.png",
                    width: 10,
                    height: 18,
                  ),
                ),
              ),
              Text(
                "${widget.reportType == ReportType.faceVerification ? "Face Verification" : "Anomaly Detection"} Report",
                style: getTextStyle(
                    textColor: AppColors.secondaryYellow,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 20),
              )
            ],
          ),
        ),
      );
}
