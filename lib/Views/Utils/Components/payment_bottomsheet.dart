import 'package:charity_app/Controllers/firestore_controller.dart';
import 'package:charity_app/Views/Utils/Components/common_field.dart';
import 'package:charity_app/Views/Utils/Components/login_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

import '../../User/charity_success.dart';
import '../Styles/app_colors.dart';
import '../Styles/text_styles.dart';

class DonationBottomSheet extends StatefulWidget {
  final String feedName;
  final String charityID;
  const DonationBottomSheet({
    super.key,
    required this.feedName,
    required this.charityID,
  });

  @override
  State<DonationBottomSheet> createState() => _DonationBottomSheetState();
}

class _DonationBottomSheetState extends State<DonationBottomSheet> {
  final amountController = TextEditingController();
  final cardNoController = TextEditingController();
  final cvvController = TextEditingController();
  final expDateController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  final key = GlobalKey<FormState>();
  FirestoreController firestoreController = Get.put(FirestoreController());

  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateTimeController.text = _selectedDate.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Donate Now',
                          style: CustomTextStyles.mediumBlackColorStyle,
                        ),
                        Text(
                          '${widget.feedName}',
                          style: CustomTextStyles.smallGreyColorStyle,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      "Amount",
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                  ),
                  CommonTextField(
                    hintText: 'Amount',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: amountController,
                    icon: Icon(
                      Icons.attach_money,
                      color: AppColors.themeColor,
                    ),
                    validate: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Amount is required';
                      }
                      return null;
                    },
                    obsecureText: false,
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      "Debit Card Number",
                      style: CustomTextStyles.mediumBlackColorStyle2,
                    ),
                  ),
                  CommonTextField(
                    hintText: '0000 0000 0000 0000',
                    maxLength: 16,
                    controller: cardNoController,
                    icon: Icon(
                      FontAwesomeIcons.creditCard,
                      color: AppColors.themeColor,
                    ),
                    validate: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Card No. is required';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // CreditCardNumberInputFormatter()
                    ],
                    obsecureText: false,
                  ),
                  // SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Text(
                                "Exp. Date",
                                style: CustomTextStyles.mediumBlackColorStyle2,
                              ),
                            ),
                            CommonTextField(
                              controller: dateTimeController,
                              maxLength: 20,
                              validate: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'date is required';
                                }
                                return null;
                              },
                              obsecureText: false,
                              icon: IconButton(
                                  onPressed: () {
                                    _selectDate();
                                  },
                                  icon: Icon(
                                    Icons.access_alarm,
                                    color: AppColors.themeColor,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Text(
                                "CVV",
                                style: CustomTextStyles.mediumBlackColorStyle2,
                              ),
                            ),
                            CommonTextField(
                              controller: cvvController,
                              hintText: '000',
                              maxLength: 3,
                              validate: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'CVV is required';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              obsecureText: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  CommonButton(
                    child: firestoreController.loader.value == true
                        ? CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          )
                        : Text(
                            'Donate',
                            style: CustomTextStyles.commonButtonStyle,
                          ),
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        String id = randomAlphaNumeric(7);
                        Map<String, dynamic> itemDetails = {
                          'donation_id': id,
                          'amount': amountController.text.toString(),
                          'cardNo': cardNoController.text.toString(),
                          'card_exp_date': dateTimeController.text.toString(),
                          'cvv': cvvController.text.toString(),
                          'charity_post_id': widget.charityID.toString(),
                          'time': Timestamp.now(),
                        };

                        await firestoreController
                            .addData(itemDetails, id, 'Payments')
                            .then((value) => {
                                  Get.snackbar(
                                      'Success', 'Donate Successfully'),
                                  Get.to(() => CharitySuccess()),
                                });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
