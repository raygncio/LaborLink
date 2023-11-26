import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class SuggestedFee extends StatefulWidget {
  const SuggestedFee({Key? key, required this.getFee}) : super(key: key);

  final Function(double) getFee;

  @override
  State<SuggestedFee> createState() => _SuggestedFeeState();
}

class _SuggestedFeeState extends State<SuggestedFee> {
  double suggestedFee = 0; // Variable to store suggested fee
  double convenienceFee = 0;
  double totalFee = 0;

  getTotal(String value) {
    suggestedFee = double.tryParse(value) ?? 0;
    convenienceFee = suggestedFee * 0.10;

    setState(() {
      totalFee = suggestedFee + convenienceFee;
    });

    widget.getFee(totalFee);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Suggested Service Fee",
          style: getTextStyle(
            textColor: AppColors.accentOrange,
            fontFamily: AppFonts.montserrat,
            fontWeight: AppFontWeights.semiBold,
            fontSize: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 152,
            height: 27,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: AppColors.accentOrange),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Text(
                    "PHP",
                    style: getTextStyle(
                      textColor: AppColors.accentOrange,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4), // Adjust the padding as needed
                      child: TextField(
                        onChanged: (value) {
                          getTotal(value);
                        },
                        keyboardType: TextInputType.number,
                        style: getTextStyle(
                          textColor: AppColors.accentOrange,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: 10,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  height: 98,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: AppColors.orangeBadge,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 11, top: 8),
                            child: Text(
                              "Breakdown",
                              style: getTextStyle(
                                textColor: AppColors.accentOrange,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 66),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 38),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Suggested Fee",
                                      style: getTextStyle(
                                        textColor: AppColors.accentOrange,
                                        fontFamily: AppFonts.montserrat,
                                        fontWeight: AppFontWeights.regular,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Convenience Fee",
                                      style: getTextStyle(
                                        textColor: AppColors.accentOrange,
                                        fontFamily: AppFonts.montserrat,
                                        fontWeight: AppFontWeights.regular,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Php ${suggestedFee.toString()}",
                                    style: getTextStyle(
                                      textColor: AppColors.accentOrange,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.regular,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Php ${convenienceFee.toStringAsFixed(2)}',
                                    style: getTextStyle(
                                      textColor: AppColors.accentOrange,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.regular,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 53, right: 13, top: 7),
                          child: Divider(
                            color: AppColors.accentOrange,
                            thickness: 0.7,
                            height: 0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, right: 12),
                          child: Text(
                            "Php $totalFee",
                            style: getTextStyle(
                              textColor: AppColors.accentOrange,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
