import 'dart:io';

import 'package:charity_app/Controllers/firestore_controller.dart';
import 'package:charity_app/Views/Admin/admin_panel.dart';
import 'package:charity_app/Views/Utils/Components/login_button.dart';
import 'package:charity_app/Views/Utils/Styles/app_colors.dart';
import 'package:charity_app/Views/Utils/Styles/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import '../Utils/Components/common_field.dart';
import '../Utils/Components/pick_image.dart';

class AddDonationPost extends StatefulWidget {
  const AddDonationPost({super.key});

  @override
  State<AddDonationPost> createState() => _AddDonationPostState();
}

class _AddDonationPostState extends State<AddDonationPost> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  File? image;
  String imageUrlFireStore = '';
  final key = GlobalKey<FormState>();

  FirestoreController firestoreController = Get.put(FirestoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.themeColor,
        title: Text(
          'ADD POST',
          style: CustomTextStyles.appBarWhiteSmallStyle,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickImageWidget(
                    onPressed: () {
                      getImage();
                    },
                    text: "Pick A Donation Post Image",
                    image: image,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Title',
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                  ),
                  CommonTextField(
                    controller: titleController,
                    validate: (val) {
                      if (val == null || val.isEmpty) {
                        return "Title is necessary";
                      }
                      return null;
                    },
                    maxLines: 1,
                    obsecureText: false,
                    hintText: "Title of Donation",
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Description of Post',
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                  ),
                  CommonTextField(
                    controller: descController,
                    validate: (val) {
                      if (val == null || val.isEmpty) {
                        return "Description is necessary";
                      }
                      return null;
                    },
                    obsecureText: false,
                    hintText: "Description",
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CommonButton(
          child: Obx(
            () => firestoreController.loader.value
                ? CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  )
                : Text(
                    'Save',
                    style: CustomTextStyles.commonButtonStyle,
                  ),
          ),
          onPressed: () async {
            if (key.currentState!.validate()) {
              String UniqueFileName =
                  DateTime.now().millisecondsSinceEpoch.toString();
              // Creating instance of Firebase Cloud
              Reference referenceRoot = FirebaseStorage.instance.ref();
              // Creating here images folder inside the Firebase Cloud
              Reference referenceDirImages =
                  referenceRoot.child('CharityImages');

              // Passing the name to the uploaded image
              Reference referenceImageToUpload =
                  referenceDirImages.child(UniqueFileName);

              try {
                // Uploading the image to Firebase Cloud, with path
                await referenceImageToUpload.putFile(File(image!.path));
                imageUrlFireStore =
                    await referenceImageToUpload.getDownloadURL();
              } catch (e) {
                //  Handle Errors here..
              }
              String id = randomAlphaNumeric(7);
              Map<String, dynamic> itemDetails = {
                'id': id,
                'charity title': titleController.text.toString(),
                'description': descController.text.toString(),
                'image': imageUrlFireStore,
                'timestamp': Timestamp.now(),
              };

              await firestoreController
                  .addData(itemDetails, id, 'Donation')
                  .then((value) => {
                        Get.snackbar('Success', 'Post Created Successfully'),
                        Get.off(() => AdminPanel()),
                      });
            }
          },
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File tempImage = File(pickedFile.path);

      int fileSize = await tempImage.length();
      if (fileSize <= 2 * 1024 * 1024) {
        image = tempImage;
        debugPrint("Image path: ${image!.path}");
        setState(() {});
      } else {
        Get.snackbar(
          'Warning',
          'The selected image is too large. Please choose an image smaller than 2MB.',
        );
      }
    }
  }
}
