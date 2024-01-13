import 'package:laborlink/models/results/face_results.dart';
import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class FaceItem extends StatelessWidget {
  const FaceItem({super.key, required this.result});

  final FaceResults result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Result ID:     ${result.faceResultId!}',
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: 8),
            ),
            const SizedBox(
              height: 5,
            ), // fixed spacing
            Row(
              children: [
                Text(
                  result.result ?? ' ',
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
                const Spacer(),
                if (result.result2 != null)
                  Text(
                    result.result2 ?? ' ',
                    style: getTextStyle(
                        textColor: AppColors.black,
                        fontFamily: AppFonts.poppins,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: 8),
                  ),
                const Spacer(), // space
                Container(
                  width: 60,
                  child: Image.network(result.attachment ?? ' '),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  child: Image.network(result.attachment2 ?? ' '),
                ),
                const Spacer(),
                if (result.attachment3 != null)
                  Container(
                    width: 60,
                    child: Image.network(result.attachment3 ?? ' '),
                  ),
                const Spacer(), // space
                // Text(
                //   result.result,
                //   style: getTextStyle(
                //       textColor: AppColors.black,
                //       fontFamily: AppFonts.poppins,
                //       fontWeight: AppFontWeights.semiBold,
                //       fontSize: 8),
                // ),
                // const Spacer(), // space
                Text(
                  result.createdAt.toString(),
                  style: getTextStyle(
                      textColor: AppColors.black,
                      fontFamily: AppFonts.poppins,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
