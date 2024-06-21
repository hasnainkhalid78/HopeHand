import 'package:flutter/material.dart';

import 'app_colors.dart';

extension CustomTextStyles on TextStyle {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
  );

  static const TextStyle appBarStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
  );
  static const TextStyle appBarWhiteSmallStyle = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w500,
    fontFamily: 'poppins',
    color: AppColors.whiteColor,
  );

  static const TextStyle appBarWhiteStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
    fontFamily: 'poppins',
  );

  static const TextStyle splashTitle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    color: Colors.white,
  );

  static const TextStyle splashBlackTitle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    color: AppColors.blackColor,
  );

  static const TextStyle drawerElementsStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'poppins',
    color: Colors.white,
  );

  static const TextStyle commonButtonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    color: Colors.white,
  );

  static const TextStyle smallThemedColorStyle = TextStyle(
    fontFamily: 'poppins',
    color: AppColors.themeColor,
  );

  static const TextStyle smallBlackColorStyle = TextStyle(
    fontFamily: 'poppins',
    color: Colors.black,
  );

  static const TextStyle mediumBlackColorStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    fontSize: 18,
    color: Colors.black,
  );

  static const TextStyle mediumBlackColorStyle2 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle mediumThemeColorColorStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    fontSize: 16,
    color: AppColors.themeColor,
  );

  static const TextStyle mediumWhiteColorStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    fontSize: 18,
    color: AppColors.whiteColor,
  );
  static const TextStyle largeWhiteColorStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    fontSize: 35,
    color: AppColors.whiteColor,
  );

  static const TextStyle mediumGreyColorStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'poppins',
    fontSize: 18,
    color: AppColors.greyColor,
  );

  static const TextStyle smallGreyColorStyle = TextStyle(
    fontFamily: 'poppins',
    color: Colors.grey,
  );

  static const TextStyle smallWhiteColorStyle = TextStyle(
    fontFamily: 'poppins',
    color: AppColors.whiteColor,
  );

  static const TextStyle simpleFontFamily = TextStyle(
    fontFamily: 'poppins',
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: 'poppins',
    fontSize: 22,
    // color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bookDineInButtonStyle = TextStyle(
    fontFamily: 'poppins',
    fontSize: 22,
    color: AppColors.whiteColor,
    fontWeight: FontWeight.bold,
  );
}
