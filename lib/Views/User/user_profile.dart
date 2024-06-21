import 'package:charity_app/Controllers/firebase_auth_controller.dart';
import 'package:charity_app/Views/Utils/Styles/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/Styles/text_styles.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseController controller = Get.put(FirebaseController());

  User? currentUser;
  String? userName;
  checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        currentUser = user;
        if (currentUser != null) {
          FirebaseFirestore.instance
              .collection('auth')
              .doc(currentUser!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              setState(() {
                userName = documentSnapshot['name'];
              });
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Text(
          "My Account",
          style: CustomTextStyles.appBarWhiteSmallStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: AppColors.skyBlueThemeColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.themeColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${userName}",
                          style: CustomTextStyles.mediumBlackColorStyle2,
                        ),
                        Text(
                          currentUser != null
                              ? "${currentUser!.email}"
                              : 'example@gmail.com',
                          style: CustomTextStyles.smallGreyColorStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  return tile(
                    titles[index],
                    icons[index],
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.logOut();
              },
              child: tile('Logout', Icons.logout),
            )
          ],
        ),
      ),
    );
  }

  Widget tile(String text, IconData icon) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.themeColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      title: Text(
        text.toString(),
        style: CustomTextStyles.mediumBlackColorStyle2,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20,
      ),
    );
  }

  List icons = [
    Icons.lock,
    Icons.notification_add,
    Icons.question_answer,
    Icons.contact_phone,
    Icons.edit_document,
    // Icons.logout,
  ];

  List titles = [
    'Forget Password',
    'Notifications',
    'FAQ\'s',
    'Contact Us',
    'Terms & Conditions',
    // 'Logout'
  ];
}
