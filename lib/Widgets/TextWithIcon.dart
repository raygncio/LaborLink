import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class TextWithIcon extends StatelessWidget {
  final Icon icon;
  final String text;
  final double fontSize;
  final double? contentPadding;
  const TextWithIcon(
      {Key? key,
      this.contentPadding,
      required this.icon,
      required this.text,
      required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: contentPadding ?? 5),
          child: icon,
        ),
        Text(text,
            style: getTextStyle(
                textColor: AppColors.black,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.regular,
                fontSize: fontSize)),
      ],
    );
  }
}
