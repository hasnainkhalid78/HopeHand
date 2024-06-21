import 'package:charity_app/Controllers/firestore_controller.dart';
import 'package:charity_app/Views/Admin/add_donation_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/firebase_auth_controller.dart';
import '../Utils/Styles/app_colors.dart';
import '../Utils/Styles/text_styles.dart';
import '../app_text/app_text.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  Stream? donationStream;
  FirestoreController firestoreController = Get.put(FirestoreController());
  String postID = '';
  getStreamData() async {
    donationStream = await firestoreController.getData('Donation');
    setState(() {});
  }

  @override
  void initState() {
    getStreamData();
    super.initState();
  }

  FirebaseController firebaseController = Get.put(FirebaseController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Text(
          'Admin Panel',
          style: CustomTextStyles.appBarWhiteSmallStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              firebaseController.logOut();
            },
            icon: Icon(
              Icons.logout,
              color: AppColors.whiteColor,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: donationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: List.generate(
                snapshot.data.docs.length,
                (index) {
                  DocumentSnapshot donation = snapshot.data.docs[index];
                  postID = donation['id'];
                  Timestamp timestamp = donation['timestamp'];
                  DateTime dateTime = timestamp.toDate();
                  // Format the DateTime object to a readable string
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(dateTime);
                  // String formattedTime = DateFormat('kk:mm').format(dateTime);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 5,
                            color: AppColors.greyWithLowOpacity,
                            spreadRadius: 0.3,
                          )
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(donation['image']),
                        ),
                        title: Text(
                          donation['charity title'],
                          style: CustomTextStyles.smallBlackColorStyle,
                        ),
                        subtitle: Text(
                          formattedDate,
                          style: CustomTextStyles.smallGreyColorStyle,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.themeColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: AppColors.whiteColor,
                                ),
                                onPressed: () {
                                  Get.dialog(AlertDialog(
                                    content: Text(
                                      "Are you sure you want to delete this?",
                                    ),
                                    title: AppText(
                                      title: "Title",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          firestoreController
                                              .deleteData(
                                            postID,
                                            'Donation',
                                          )
                                              .then((_) {
                                            Get.back();
                                            Get.snackbar(
                                              'Success',
                                              'Post Deleted Successfully',
                                            );
                                          });
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  ));
                                },
                                color: AppColors.themeColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.themeColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: AppColors.whiteColor,
                                ),
                                onPressed: () {},
                                color: AppColors.themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        isExtended: true,
        backgroundColor: AppColors.themeColor,
        onPressed: () {
          Get.to(() => AddDonationPost());
        },
        child: Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
        // child: Text(
        //   "Add Post",
        //   style: CustomTextStyles.smallWhiteColorStyle,
        // ),
      ),
    );
  }
}
