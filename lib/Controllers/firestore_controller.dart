import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreController extends GetxController {
  RxBool loader = false.obs;

  Future<Stream<QuerySnapshot>> getData(String collectionName) async {
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .snapshots();
  }

  Future addData(
      Map<String, dynamic> data, String id, String collectionName) async {
    try {
      loader.value = true;
      update();
      return await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .set(data)
          .then((_) {
        loader.value = false;
        update();
      });
    } catch (e) {
      loader.value = false;
      update();
      print(e.toString());
    }
  }

  Future deleteData(String id, String collectionName) async {
    loader.value = true;
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .delete()
        .then((_) {
      loader.value = false;
    }).onError((error, stackTrace) {
      loader.value = false;
      Get.snackbar('error', 'Something went wrong');
      print(error);
    });
  }

  Future UpdateData(
      String id, Map<String, dynamic> itemDetails, String collection) async {
    loader.value = true;
    final docRef = FirebaseFirestore.instance.collection(collection).doc(id);
    final doc = await docRef.get();

    if (doc.exists) {
      loader.value = false;
      return await docRef.update(itemDetails).then((_) {
        Get.back();
      });
    } else {
      loader.value = false;
      print('Document does not exist');
    }
  }
}
