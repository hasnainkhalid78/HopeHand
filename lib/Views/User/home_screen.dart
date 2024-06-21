import 'package:charity_app/Controllers/firebase_auth_controller.dart';
import 'package:charity_app/Controllers/firestore_controller.dart';
import 'package:charity_app/Views/Utils/Components/charity_post.dart';
import 'package:charity_app/Views/Utils/Styles/app_colors.dart';
import 'package:charity_app/Views/Utils/Styles/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseController firebaseController = Get.put(FirebaseController());
  FirestoreController firestoreController = Get.put(FirestoreController());

  Stream? donationStream;
  getStreamData() async {
    donationStream = await firestoreController.getData('Donation');
    setState(() {});
  }

  @override
  void initState() {
    getStreamData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Text(
          'Charity Feed',
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
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  snapshot.data.docs.length,
                  (index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    // Convert the timestamp to a DateTime object
                    Timestamp timestamp = ds['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    // Format the DateTime object to a readable string
                    String formattedDate =
                        DateFormat('yyyy-MM-dd - kk:mm').format(dateTime);
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CharityPost(
                        imagePath: ds['image'],
                        title: ds['charity title'],
                        charityID: ds['id'],
                        time: formattedDate,
                        feedName: ds['charity title'],
                      ),
                    );
                  },
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
    );
  }
}
