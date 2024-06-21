import 'package:charity_app/Controllers/firebase_auth_controller.dart';
import 'package:charity_app/Views/Utils/Styles/text_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/Components/common_field.dart';
import '../Utils/Components/login_button.dart';
import '../Utils/Styles/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var cpasswordcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  FirebaseController firebaseController = Get.put(FirebaseController());

  // Confirming the both password fields are same or not
  String? matchPassword(value) {
    if (value!.isEmpty) {
      return 'Confirm Password Field must be filled';
    } else if (passwordcontroller.text.toString() !=
        cpasswordcontroller.text.toString()) {
      return "Password not match";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -30,
            child: Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(250)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create account',
                        style: CustomTextStyles.appBarStyle,
                      ),
                      const Text(
                        'Sign up to begin your jounery',
                        style: CustomTextStyles.smallGreyColorStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Full name',
                        style: CustomTextStyles.smallBlackColorStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CommonTextField(
                        controller: namecontroller,
                        ketboardType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Name Field cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        obsecureText: false,
                        hintText: 'Your name here',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Email',
                        style: CustomTextStyles.smallBlackColorStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CommonTextField(
                        controller: emailcontroller,
                        hintText: "abc@example.com",
                        ketboardType: TextInputType.emailAddress,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Email must be given";
                          } else if (!EmailValidator.validate(val)) {
                            return "In-Correct Email Format";
                          } else {
                            return null;
                          }
                        },
                        obsecureText: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Password',
                        style: CustomTextStyles.smallBlackColorStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CommonTextField(
                        controller: passwordcontroller,
                        ketboardType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Password field cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 1,
                        obsecureText: true,
                        hintText: 'Type pasword here',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Confrim Password',
                        style: CustomTextStyles.smallBlackColorStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CommonTextField(
                        controller: cpasswordcontroller,
                        obsecureText: true,
                        hintText: "Confirm Password",
                        ketboardType: TextInputType.text,
                        validate: matchPassword,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: CommonButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              firebaseController.createUserWithEmailAndPassword(
                                  emailcontroller.text,
                                  passwordcontroller.text,
                                  namecontroller.text);
                            }
                          },
                          child: Obx(
                            () => firebaseController.loader.value
                                ? CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                  )
                                : Text(
                                    'Sign-Up',
                                    style: CustomTextStyles.commonButtonStyle,
                                  ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Alread a member?",
                            style: CustomTextStyles.smallGreyColorStyle,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Sign-In",
                              style: CustomTextStyles.smallThemedColorStyle,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
