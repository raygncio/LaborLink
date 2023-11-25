import 'package:laborlink/ai/style.dart';
import 'package:flutter/material.dart';

class CommonWidgets {
  // custom widget
  // static method that returns a widget
  static Widget customExtendedButton({
    required String text,
    required BuildContext context,
    required onTap,
    double? width,
    required bool isClickable,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isClickable ? 1 : 0.4,
        child: Container(
          width: width,
          height: 60,
          decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: getTextStyle(
                textColor: AppColors.white,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
