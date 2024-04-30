import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/services.dart';
// import 'package:open_document/open_document.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/models/results/face_results.dart';
import 'package:laborlink/models/request.dart';

class AnomalyCustomRow {
  final String resultId;
  final String idType;
  final Uint8List attachment;
  final String result;
  final String createdAt;

  AnomalyCustomRow(
      this.resultId, this.idType, this.attachment, this.result, this.createdAt);
}

class FaceCustomRow {
  final String faceResultId;
  final List<Uint8List> attachments;
  final List<String> results;
  final double average;
  final String verdict;
  final String createdAt;

  FaceCustomRow(this.faceResultId, this.attachments, this.results, this.average,
      this.verdict, this.createdAt);
}

class IncomeCustomRow {
  final String requestId;
  final String title;
  final String userId;
  final String handymanId;
  final String category;
  final double price;
  final double income;
  final String createdAt;

  IncomeCustomRow(this.requestId, this.title, this.userId, this.handymanId,
      this.category, this.price, this.income, this.createdAt);
}

class PdfInvoiceService {
  // CREATE INCOME REPORT PDF--------------------------------------------------
  Future<Uint8List> createIncomeReport(List<Request> completedRequests) async {
    final pdf = pw.Document();
    // double newPrice = result.suggestedPrice;
    // double origPrice = 0.0;
    // double income = 0.0;

    // origPrice = newPrice / (1 + 0.10);
    // income = newPrice - origPrice;

    // INITIALIZE ELEMENTS
    final List<IncomeCustomRow> elements = [
      for (var result in completedRequests)
        IncomeCustomRow(
          result.requestId!,
          result.title,
          result.userId,
          result.handymanId!,
          result.category,
          result.suggestedPrice,
          (result.suggestedPrice - (result.suggestedPrice / 1.10)),
          result.createdAt.toString().substring(0, 16),
        ),
    ];

    // LOAD IMAGES
    final logo =
        (await rootBundle.load("assets/icons/LOGO 1.png")).buffer.asUint8List();

    // INCOME REPORT ADD PAGE

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // HEADER
            pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(logo)),
                  // pw.Image(pw.MemoryImage(imageResults[0])),
                  pw.SizedBox(height: 20),
                  pw.Text("LaborLink Income Report",
                      textAlign: pw.TextAlign.center),
                  pw.Text("For the month of January",
                      textAlign: pw.TextAlign.center),
                  pw.SizedBox(height: 25),
                ],
              ),
            ),

            // BODY
            // COLUMN TITLES
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Request Id', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Title', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('User Id', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child:
                        pw.Text('Handyman Id', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Category', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Suggested Price',
                        textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Gain', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child:
                        pw.Text('Created At', textAlign: pw.TextAlign.center)),
              ],
            ),
            pw.SizedBox(height: 20),

            // CONTENTS
            for (var element in elements)
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text(element.requestId,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.title,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.userId,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.handymanId,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.category,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.price.toStringAsFixed(2),
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.income.toStringAsFixed(2),
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.createdAt,
                            textAlign: pw.TextAlign.center)),
                  ],
                ),
              ),

            pw.SizedBox(height: 20),

            // FOOTER

            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text('Total Acquired Value',
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(getTotalAcquiredValue(elements),
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Total Income', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(getTotalIncome(elements),
                        textAlign: pw.TextAlign.right)),
              ],
            ),

            // FOOTER
            pw.SizedBox(height: 25),
            pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("END"),
                  pw.SizedBox(height: 25),
                ],
              ),
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  // CREATE ANOMALY REPORT PDF--------------------------------------------------
  Future<Uint8List> createAnomalyReport(
      List<AnomalyResults> anomalyResults) async {
    final pdf = pw.Document();

    // INITIALIZE ELEMENTS
    final List<AnomalyCustomRow> elements = [
      for (var result in anomalyResults)
        AnomalyCustomRow(
          result.anomalyResultId!,
          result.idType,
          await convertedImage(result.attachment),
          //result.attachment,
          result.result,
          result.createdAt.toString(),
        ),
    ];

    // LOAD IMAGES
    final logo =
        (await rootBundle.load("assets/icons/LOGO 1.png")).buffer.asUint8List();

    List<Uint8List> imageResults = [];
    for (var result in anomalyResults) {
      imageResults.add(await convertedImage(result.attachment));
    }

    // ANOMALY DETECTION REPORT ADD PAGE

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // HEADER
            pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(logo)),
                  // pw.Image(pw.MemoryImage(imageResults[0])),
                  pw.SizedBox(height: 20),
                  pw.Text("LaborLink Anomaly Detection Report",
                      textAlign: pw.TextAlign.center),
                  pw.SizedBox(height: 25),
                ],
              ),
            ),

            // BODY
            // COLUMN TITLES
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Result Id', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Id Type', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child:
                        pw.Text('Attachment', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Result', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child:
                        pw.Text('Created At', textAlign: pw.TextAlign.center)),
              ],
            ),
            pw.SizedBox(height: 20),

            // CONTENTS
            for (var element in elements)
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text(element.resultId,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.idType,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                      child: pw.Image(
                        pw.MemoryImage(element.attachment),
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Text(
                            element.result == 'noanomaly'
                                ? 'No Anomaly'
                                : 'Has Anomaly',
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.createdAt,
                            textAlign: pw.TextAlign.center)),
                  ],
                ),
              ),

            pw.SizedBox(height: 20),

            // FOOTER

            // Total Count
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Total Count', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(getAnomalyTotalCount(anomalyResults),
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text('Total NBI', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(getNBICount(anomalyResults),
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Total Tesda', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(getTesdaCount(anomalyResults),
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Anomaly Count', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(
                        '${getAnomalyCount(anomalyResults)}/${getAnomalyTotalCount(anomalyResults)}',
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child: pw.Text('${getAnomalyPercentage(anomalyResults)}%',
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text('No Anomaly Count',
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(
                        '${getNoAnomalyCount(anomalyResults)}/${getAnomalyTotalCount(anomalyResults)}',
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child: pw.Text('${getNoAnomalyPercentage(anomalyResults)}%',
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.SizedBox(height: 20),

            // FOOTER
            pw.SizedBox(height: 25),
            pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("END"),
                  pw.SizedBox(height: 25),
                ],
              ),
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  // CREATE FACE REPORT PDF ----------------------------------------------------

  Future<Uint8List> createFaceReport(List<FaceResults> faceResults) async {
    final pdf = pw.Document();

    // INITIALIZE ELEMENTS
    final List<FaceCustomRow> elements = [];

    for (int i = 0; i < faceResults.length; i++) {
      List<Uint8List> faces = [];
      List<String> results = [];
      double average = 0.0;
      String verdict = 'PASSED'; //by default

      faces.add(await convertedImage(faceResults[i].attachment!));
      faces.add(await convertedImage(faceResults[i].attachment2!));
      results.add(faceResults[i].result!);
      average = double.parse(faceResults[i].result!);

      // if there are 3 attachments and 2 results
      if (faceResults[i].attachment3 != null) {
        faces.add(await convertedImage(faceResults[i].attachment3!));
        results.add(faceResults[i].result2!);

        // get average
        average = (double.parse(faceResults[i].result!) +
                double.parse(faceResults[i].result2!)) /
            2;

        // get verdict and single out result
        if (double.parse(faceResults[i].result2!) == 0) {
          verdict = 'FAILED';
          average = double.parse(faceResults[i].result!);
        }

        // single out result
        if (double.parse(faceResults[i].result!) == 0) {
          average = double.parse(faceResults[i].result2!);
        }
      }

      // get verdict
      if (double.parse(faceResults[i].result!) == 0) {
        verdict = 'FAILED';
      }

      elements.add(FaceCustomRow(
        faceResults[i].faceResultId!,
        faces,
        results,
        average,
        verdict,
        faceResults[i].createdAt!.toString(),
      ));
    }

    // LOAD IMAGES
    final logo =
        (await rootBundle.load("assets/icons/LOGO 1.png")).buffer.asUint8List();

    // FACE VERIFICATION REPORT ADD PAGE

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // HEADER
            pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(logo)),
                  // pw.Image(pw.MemoryImage(imageResults[0])),
                  pw.SizedBox(height: 20),
                  pw.Text("LaborLink Face Verification Report",
                      textAlign: pw.TextAlign.center),
                  pw.SizedBox(height: 25),
                ],
              ),
            ),

            // BODY
            // COLUMN TITLES
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Result Id', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Faces', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Results', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Average', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text('Verdict', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child:
                        pw.Text('Created At', textAlign: pw.TextAlign.center)),
              ],
            ),
            pw.SizedBox(height: 20),

            // CONTENTS

            for (var element in elements)
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text(element.faceResultId,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          for (var attachment in element.attachments)
                            pw.Image(
                              width: 40,
                              pw.MemoryImage(attachment),
                            ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          for (var result in element.results)
                            pw.Text(result, textAlign: pw.TextAlign.center),
                        ],
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Text(element.average.toStringAsFixed(2),
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.verdict,
                            textAlign: pw.TextAlign.center)),
                    pw.Expanded(
                        child: pw.Text(element.createdAt,
                            textAlign: pw.TextAlign.center)),
                  ],
                ),
              ),

            pw.SizedBox(height: 20),

            // FOOTER

            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Total Count', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(getFaceTotalCount(elements),
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Total Passed', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(
                        '${getPassedCount(elements)}/${getFaceTotalCount(elements)}',
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child: pw.Text('${getPassedPercentage(elements)}%',
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        pw.Text('Total Failed', textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(
                        '${getFailedCount(elements)}/${getFaceTotalCount(elements)}',
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child: pw.Text('${getFailedPercentage(elements)}%',
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text('Average Accuracy',
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
                pw.Expanded(
                    child: pw.Text(getAverageAccuracy(elements),
                        textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.SizedBox(height: 20),

            // FOOTER
            pw.SizedBox(height: 25),
            pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("END"),
                  pw.SizedBox(height: 25),
                ],
              ),
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> convertedImage(String imageUrl) async {
    final imageBytes =
        (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
            .buffer
            .asUint8List();

    return imageBytes;
  }

  Future<String> savePdfFile(String fileName, Uint8List byteList) async {
    bool dirDownloadExists = true;
    var directory = "/storage/emulated/0/Download/";

    dirDownloadExists = await Directory(directory).exists();
    if (dirDownloadExists) {
      directory = "/storage/emulated/0/Download/";
    } else {
      directory = "/storage/emulated/0/Downloads/";
    }

    try {
      var filePath = "$directory$fileName.pdf".replaceAll(':', '-');
      final file = File(filePath);
      await file.writeAsBytes(byteList);
      // await OpenDocument.openDocument(filePath: filePath);

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  // ANOMALY STATS -------------------------------------------------------------

  String getAnomalyTotalCount(List<AnomalyResults> anomalyResults) {
    return anomalyResults.length.toString();
  }

  String getNBICount(List<AnomalyResults> anomalyResults) {
    int count = 0;
    for (var result in anomalyResults) {
      if (result.idType.toLowerCase() == 'nbi') {
        count++;
      }
    }
    return count.toString();
  }

  String getTesdaCount(List<AnomalyResults> anomalyResults) {
    int count = 0;
    for (var result in anomalyResults) {
      if (result.idType.toLowerCase() == 'tesda') {
        count++;
      }
    }
    return count.toString();
  }

  String getAnomalyCount(List<AnomalyResults> anomalyResults) {
    int count = 0;
    for (var result in anomalyResults) {
      if (result.result.toLowerCase() == 'hasanomaly') {
        count++;
      }
    }
    return count.toString();
  }

  String getNoAnomalyCount(List<AnomalyResults> anomalyResults) {
    int count = 0;
    for (var result in anomalyResults) {
      if (result.result.toLowerCase() == 'noanomaly') {
        count++;
      }
    }
    return count.toString();
  }

  String getAnomalyPercentage(List<AnomalyResults> anomalyResults) {
    int count = int.parse(getAnomalyCount(anomalyResults));
    return ((count / int.parse(getAnomalyTotalCount(anomalyResults))) * 100)
        .toString();
  }

  String getNoAnomalyPercentage(List<AnomalyResults> anomalyResults) {
    int count = int.parse(getNoAnomalyCount(anomalyResults));
    return ((count / int.parse(getAnomalyTotalCount(anomalyResults))) * 100)
        .toString();
  }

  // FACE STATS ----------------------------------------------------------------
  String getFaceTotalCount(List<FaceCustomRow> faceResults) {
    return faceResults.length.toString();
  }

  String getPassedCount(List<FaceCustomRow> faceResults) {
    int count = 0;
    for (var result in faceResults) {
      if (result.verdict.toLowerCase() == 'passed') {
        count++;
      }
    }
    return count.toString();
  }

  String getFailedCount(List<FaceCustomRow> faceResults) {
    int count = 0;
    for (var result in faceResults) {
      if (result.verdict.toLowerCase() == 'failed') {
        count++;
      }
    }
    return count.toString();
  }

  String getPassedPercentage(List<FaceCustomRow> faceResults) {
    int count = int.parse(getPassedCount(faceResults));
    return ((count / int.parse(getFaceTotalCount(faceResults))) * 100)
        .toStringAsFixed(2);
  }

  String getFailedPercentage(List<FaceCustomRow> faceResults) {
    int count = int.parse(getFailedCount(faceResults));
    return ((count / int.parse(getFaceTotalCount(faceResults))) * 100)
        .toStringAsFixed(2);
  }

  String getAverageAccuracy(List<FaceCustomRow> faceResults) {
    int count = 0;
    double total = 0;
    double ave = 0;
    for (var result in faceResults) {
      if (result.results.length == 1) {
        if (result.results[0] == '0.00') {
          continue;
        }
      }
      count++;
      total += result.average;
    }
    ave = total / count;
    return (ave.toStringAsFixed(2));
  }

  // INCOME STATS --------------------------------------------------------------

  String getTotalAcquiredValue(List<IncomeCustomRow> completedRequests) {
    double total = 0.0;
    for (var result in completedRequests) {
      total += result.price;
    }
    return total.toStringAsFixed(2);
  }

  String getTotalIncome(List<IncomeCustomRow> completedRequests) {
    double total = 0.0;
    for (var result in completedRequests) {
      total += result.income;
    }
    return total.toStringAsFixed(2);
  }
}
