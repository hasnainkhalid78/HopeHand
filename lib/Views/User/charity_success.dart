import 'package:charity_app/Views/User/home_screen.dart';
import 'package:charity_app/Views/Utils/Styles/app_colors.dart';
import 'package:charity_app/Views/Utils/Styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CharitySuccess extends StatelessWidget {
  const CharitySuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You've Donated Successfully",
              style: CustomTextStyles.mediumBlackColorStyle,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
              ),
              onPressed: () {
                Get.offAll(() => HomeScreen());
              },
              child: Text(
                "Go to Feed",
                style: TextStyle(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
