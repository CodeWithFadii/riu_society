import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/Budget/model/entity_modal.dart';
import 'package:riu_society/utils/functions.dart';

class BudgetController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController titleC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  addEvent(TextEditingController controller) {
    try {
      if (controller.text.isEmpty) {
        return snackbar('Error', 'Enter event title and try again');
      }
      EasyLoading.show();
      firestore.collection('budget').add({
        'time_stamp': DateTime.now(),
        'event_title': controller.text.toString(),
        'total': 0,
      }).then((value) {
        controller.clear();
        Get.back();
        EasyLoading.dismiss();
      });
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Error',
          'Error while creating event check your internet connection or try again ');
    }
  }

  addEntity(String docID) {
    try {
      if (titleC.text.isEmpty || priceC.text.isEmpty) {
        return snackbar('Error', 'Enter entity details and try again');
      }
      EasyLoading.show();
      firestore.collection('budget').doc(docID).collection('entities').add({
        'time_stamp': DateTime.now(),
        'entity_title': titleC.text.toString(),
        'entity_price': int.parse(priceC.text),
      }).then((value) {
        titleC.clear();
        priceC.clear();
        Get.back();
        EasyLoading.dismiss();
      });
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Error',
          'Error while creating Entity check your internet connection or try again ');
    }
  }

  editEntity(String docID, String entityId) {
    try {
      if (titleC.text.isEmpty || priceC.text.isEmpty) {
        return snackbar('Error', 'Enter entity details and try again');
      }
      EasyLoading.show();
      firestore
          .collection('budget')
          .doc(docID)
          .collection('entities')
          .doc(entityId)
          .update({
        'time_stamp': DateTime.now(),
        'entity_title': titleC.text.toString(),
        'entity_price': int.parse(priceC.text),
      }).then((value) {
        titleC.clear();
        priceC.clear();
        Get.back();
        EasyLoading.dismiss();
      });
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Error',
          'Error while creating Entity check your internet connection or try again ');
    }
  }

  getEntities(String docID) {
    return FirebaseFirestore.instance
        .collection('budget')
        .doc(docID)
        .collection('entities')
        .orderBy('time_stamp', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => EntityModal.fromFireStore(doc)).toList(),
        );
  }

  deleteEvent(String eventId) {
    FirebaseFirestore.instance.collection('budget').doc(eventId).delete();
  }

  deleteEntity(String eventId, String entityId) {
    FirebaseFirestore.instance
        .collection('budget')
        .doc(eventId)
        .collection('entities')
        .doc(entityId)
        .delete();
  }
}
