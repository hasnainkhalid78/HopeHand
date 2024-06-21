import 'package:charity_app/Controllers/firestore_controller.dart';
import 'package:charity_app/Views/Utils/Styles/app_colors.dart';
import 'package:charity_app/Views/Utils/Styles/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  FirestoreController firestoreController = Get.put(FirestoreController());
  Stream? paymentStream;
  Stream? donationStream;
  getStreamData() async {
    paymentStream = await firestoreController.getData('Payments');
    setState(() {});
  }

  getStreamData2() async {
    donationStream = await firestoreController.getData('Donation');
    setState(() {});
  }

  @override
  void initState() {
    getStreamData();
    getStreamData2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Text(
          'History of Payments',
          style: CustomTextStyles.appBarWhiteSmallStyle,
        ),
      ),
      body: StreamBuilder(
        stream: paymentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: List.generate(
                snapshot.data.docs.length,
                (index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  Timestamp timestamp = ds['time'];
                  DateTime dateTime = timestamp.toDate();
                  // Format the DateTime object to a readable string
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(dateTime);
                  String formattedTime = DateFormat('kk:mm').format(dateTime);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: AppColors.greyWithLowOpacity,
                                spreadRadius: 0.3,
                              ),
                            ],
                          ),
                          child: Icon(
                            FontAwesomeIcons.creditCard,
                            color: AppColors.themeColor,
                          ),
                        ),
                        subtitle: Text('Rs ${ds['amount']}'),
                        title: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Donation')
                              .doc(ds['charity_post_id'])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.data();
                              print("Data" + '${snapshot.data}');
                              return Text(data!['charity title']);
                            } else {
                              return Text("Loading...");
                            }
                          },
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${formattedTime}',
                              style: CustomTextStyles.smallGreyColorStyle,
                            ),
                            Text(
                              '${formattedDate}',
                              style: CustomTextStyles.smallGreyColorStyle,
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
    );
  }
}
