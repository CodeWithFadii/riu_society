import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/common/notification/send_method.dart';
import 'package:riu_society/utils/functions.dart';

class TaskController extends GetxController {
  final TextEditingController descriptionC = TextEditingController();
  RxList<SubAdminModel> adminList = <SubAdminModel>[].obs;
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  getsubAdmins() async {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'sub-admin')
        .get();
    for (var i in doc.docs) {
      adminList.add(
        SubAdminModel(
            image: i['image'],
            name: i['name'],
            department: i['department'],
            id: i['id'],
            tokken: i['fcm_token'],
            selected: false),
      );
    }
  }

  assignTask() async {
    try {
      if (descriptionC.text.isEmpty) {
        return snackbar('Error', 'Enter description of task');
      }
      String name = '';
      EasyLoading.show();
      for (SubAdminModel i in adminList) {
        if (i.selected!) {
          name = i.name!;
          await FirebaseFirestore.instance.collection('tasks').add({
            'time_stamp': DateTime.now(),
            'id': i.id,
            'name': i.name,
            'image': i.image,
            'department': i.department,
            'description': descriptionC.text,
            'pending': false,
          });
          SendMethod.sendNotification(
              'Admin Assigned A Task To You', descriptionC.text, i.tokken!);
        }
      }
      if (name == '') {
        EasyLoading.dismiss();
        return snackbar('Error', 'Please select admin to assign task');
      }
      // descriptionC.clear();
      // Get.back();
      EasyLoading.dismiss();
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Error', 'Check your internet connection or tr again');
    }
  }

  getAllTasks() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('time_stamp', descending: true)
        .snapshots();
  }

  subAdminTasks() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('id', isEqualTo: userUid)
        .snapshots();
  }

  @override
  void onInit() {
    super.onInit();
    getsubAdmins();
  }
}

class SubAdminModel {
  final String? image, name, department, id, tokken;
  bool? selected;

  SubAdminModel(
      {this.department,
      this.image,
      this.name,
      this.selected,
      this.id,
      this.tokken});
}
