import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:laborlink/models/results/anomaly_results.dart';
import 'package:laborlink/models/results/face_results.dart';

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
  final String results;
  final String average;
  final String verdict;
  final String createdAt;

  FaceCustomRow(this.faceResultId, this.attachments, this.results, this.average,
      this.verdict, this.createdAt);
}

class PdfInvoiceService {
  // CREATE ANOMALY REPORT PDF
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

    // ANOMALY DETECTION REPORT PAGE
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.SizedBox(
              height: 200,
              child: pw.Column(
                children: [
                  // HEADER
                  pw.Image(pw.MemoryImage(logo)),
                  // pw.Image(pw.MemoryImage(imageResults[0])),
                  pw.SizedBox(height: 20),
                  pw.Text("LaborLink Anomaly Detection Report",
                      textAlign: pw.TextAlign.center),
                  pw.SizedBox(height: 25),

                  // BODY
                  itemColumn(elements, anomalyResults),

                  // FOOTER
                  pw.SizedBox(height: 25),
                  pw.Text("END"),
                ],
              ),
            )
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

  pw.Expanded itemColumn(
      List<AnomalyCustomRow> elements, List<AnomalyResults> anomalyResults) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          // COLUMN TITLES
          pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Text('Result Id', textAlign: pw.TextAlign.center)),
              pw.Expanded(
                  child: pw.Text('Id Type', textAlign: pw.TextAlign.center)),
              pw.Expanded(
                  child: pw.Text('Attachment', textAlign: pw.TextAlign.center)),
              pw.Expanded(
                  child: pw.Text('Result', textAlign: pw.TextAlign.center)),
              pw.Expanded(
                  child: pw.Text('Created At', textAlign: pw.TextAlign.center)),
            ],
          ),
          pw.SizedBox(height: 20),

          // CONTENTS
          for (var element in elements)
            pw.Row(
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
          pw.SizedBox(height: 20),

          // FOOTER

          // Total Count
          pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Text('Total Count', textAlign: pw.TextAlign.left)),
              pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
              pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
              pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
              pw.Expanded(
                  child: pw.Text(getTotalCount(anomalyResults),
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
                  child: pw.Text('Total Tesda', textAlign: pw.TextAlign.left)),
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
              pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
              pw.Expanded(
                  child: pw.Text(getAnomalyCount(anomalyResults),
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
              pw.Expanded(child: pw.Text('', textAlign: pw.TextAlign.center)),
              pw.Expanded(
                  child: pw.Text(getNoAnomalyCount(anomalyResults),
                      textAlign: pw.TextAlign.right)),
            ],
          ),
          pw.SizedBox(height: 20),
        ],
      ),
    );
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

  String getTotalCount(List<AnomalyResults> anomalyResults) {
    return anomalyResults.length.toString();
  }

  String getNBICount(List<AnomalyResults> anomalyResults) {
    return anomalyResults.length.toString();
  }

  String getTesdaCount(List<AnomalyResults> anomalyResults) {
    return anomalyResults.length.toString();
  }

  String getAnomalyCount(List<AnomalyResults> anomalyResults) {
    return anomalyResults.length.toString();
  }

  String getNoAnomalyCount(List<AnomalyResults> anomalyResults) {
    return anomalyResults.length.toString();
  }

  // String getVatTotal(List<Product> products) {
  //   return products
  //       .fold(
  //         0.0,
  //         (double prev, next) =>
  //             prev + ((next.price / 100 * next.vatInPercent) * next.amount),
  //       )
  //       .toStringAsFixed(2);
  // }
}
