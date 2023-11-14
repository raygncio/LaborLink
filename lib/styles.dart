library styles;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppFonts {
  static String? montserrat = GoogleFonts.montserrat().fontFamily;
  static String? poppins = GoogleFonts.poppins().fontFamily;
}

abstract final class AppColors {
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff404041);
  static const Color blackShadow = Color(0x40000000);
  static const Color primaryBlue = Color(0xff072386);
  static const Color secondaryBlue = Color(0xff314FB9);
  static const Color tertiaryBlue = Color(0xff014DAA);
  static const Color accentOrange = Color(0xffF0771F);
  static const Color secondaryYellow = Color(0xffFFCD00);
  static const Color dirtyWhite = Color(0xffF2F2F2);
  static const Color green = Color(0xff98C93C);
  static const Color pink = Color(0xffEC0677);
  static const Color grey = Color(0xff929497);
  static const Color grey61 = Color(0xff6A6A6A);
  static const Color greyD9 = Color(0xffD9D9D9);
  static const Color blueBadge = Color(0xffD7E6ED);
  static const Color orangeBadge = Color(0xffF2E6CB);
  static const Color orangeCard = Color(0x33EFB62F);
  static const Color greenBadge = Color(0xffEAF4D8);
  static const Color blackBadge = Color(0xffEAEAEA);
  static const Color pinkBadge = Color(0xffFBEDED);
  static const Color red = Color(0xffDC4C4C);
}

abstract final class AppFontWeights {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

TextStyle getTextStyle({
  required Color? textColor,
  required String? fontFamily,
  required FontWeight fontWeight,
  required double fontSize,
  textShadow,
  fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    overflow: TextOverflow.ellipsis,
    color: textColor,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    fontSize: fontSize,
    shadows: textShadow ?? [],
    fontStyle: fontStyle,
  );
}
