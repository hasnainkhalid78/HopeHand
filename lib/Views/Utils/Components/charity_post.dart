import 'package:charity_app/Views/Utils/Components/donate_btn.dart';
import 'package:charity_app/Views/Utils/Components/payment_bottomsheet.dart';
import 'package:charity_app/Views/Utils/Styles/text_styles.dart';
import 'package:charity_app/Views/User/charity_post_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Styles/app_colors.dart';

class CharityPost extends StatelessWidget {
  final String imagePath;
  final String title;
  final String time;
  final String charityID;
  final String feedName;
  CharityPost({
    super.key,
    required this.imagePath,
    required this.title,
    required this.time,
    required this.charityID,
    required this.feedName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 5,
            color: AppColors.greyWithLowOpacity,
            spreadRadius: 0.3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: CustomTextStyles.mediumBlackColorStyle,
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              time,
              style: CustomTextStyles.smallGreyColorStyle,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DonationButton(
                onPressed: () {
                  Get.to(() => CharityPostDetail(
                        id: charityID,
                      ));
                },
                child: Text(
                  'View Details',
                  style: CustomTextStyles.commonButtonStyle,
                ),
                buttonColor: AppColors.themeColorPallete,
              ),
              SizedBox(width: 10),
              DonationButton(
                onPressed: () {
                  Get.bottomSheet(
                    DonationBottomSheet(
                      feedName: feedName,
                      charityID: charityID,
                    ),
                  );
                },
                child: Text(
                  'Donate Now',
                  style: CustomTextStyles.commonButtonStyle,
                ),
                buttonColor: AppColors.blackColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
