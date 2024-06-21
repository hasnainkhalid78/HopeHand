import 'package:charity_app/Controllers/firestore_controller.dart';
import 'package:charity_app/Views/Utils/Components/login_button.dart';
import 'package:charity_app/Views/Utils/Styles/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Utils/Components/payment_bottomsheet.dart';
import '../Utils/Styles/text_styles.dart';

class CharityPostDetail extends StatefulWidget {
  const CharityPostDetail({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<CharityPostDetail> createState() => _CharityPostDetailState();
}

class _CharityPostDetailState extends State<CharityPostDetail> {
  FirestoreController firestoreController = Get.put(FirestoreController());
  String charityTitle = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Text(
          'Post Detail',
          style: CustomTextStyles.appBarWhiteSmallStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Donation')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot<Map<String, dynamic>>? ds = snapshot.data;
            charityTitle = ds!['charity title'];

            // Convert the timestamp to a DateTime object
            Timestamp timestamp = ds['timestamp'];
            DateTime dateTime = timestamp.toDate();
            // Format the DateTime object to a readable string
            String formattedDate =
                DateFormat('yyyy-MM-dd - kk:mm').format(dateTime);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          width: MediaQuery.sizeOf(context).width,
                          '${ds['image']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 25, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${ds['charity title']}',
                            style: CustomTextStyles.appBarStyle,
                          ),
                          Text(
                            '${formattedDate}',
                            style: CustomTextStyles.smallGreyColorStyle,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${ds['description']}',
                            style: CustomTextStyles.smallGreyColorStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.themeColor,
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
          child: Text(
            'Donate Now',
            style: CustomTextStyles.commonButtonStyle,
          ),
          onPressed: () {
            Get.bottomSheet(DonationBottomSheet(
              feedName: charityTitle,
              charityID: widget.id,
            ));
          },
        ),
      ),
    );
  }
}
