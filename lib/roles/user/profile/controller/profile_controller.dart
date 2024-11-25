import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/events/models/event_model.dart';
import 'package:riu_society/roles/common/notification/fcm_service.dart';
import 'package:riu_society/utils/functions.dart';

class ProfileController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController rollnoC = TextEditingController();
  RxString name = ''.obs;
  RxString department = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString image = ''.obs;
  RxString card = ''.obs;
  RxString qrCode = ''.obs;
  RxString status = ''.obs;
  RxString societyId = ''.obs;
  RxString societyName = ''.obs;
  RxString role = ''.obs;
  RxString rollNo = ''.obs;
  RxBool student = true.obs;
  RxInt membersCount = 0.obs;
  RxList<EventModel> eventsList = <EventModel>[].obs;

  Future getProfile() async {
    eventsList.clear();
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    EasyLoading.show();
    try {
      CollectionReference<Map<String, dynamic>> users =
          FirebaseFirestore.instance.collection('users');
      CollectionReference<Map<String, dynamic>> societies =
          FirebaseFirestore.instance.collection('societies');
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await users.doc(user.uid).get();
      Map<String, dynamic> data = snapshot.data()!;
      name.value = data['name'];
      department.value = data['department'];
      societyName.value = data['community_name'];
      societyId.value = data['community_id'];
      email.value = data['email'];
      phone.value = data['phone'];
      image.value = data['image'];
      card.value = data['card'];
      qrCode.value = data['qr_code'];
      status.value = data['status'];
      rollNo.value = data['roll_no'].toString();
      student.value = data['student'];
      role.value = data['role'];
      List eventsId = List.from(data['events']);
      for (var i in eventsId) {
        DocumentSnapshot doc =
            await FirebaseFirestore.instance.collection('events').doc(i).get();
        eventsList.add(EventModel(
            image: doc['image'],
            title: doc['title'],
            description: doc['description'],
            date: doc['date'],
            fee: doc['fee'],
            city: doc['city'],
            address: doc['location'],
            participants: List.from(doc['participants']),
            id: doc.id));
      }
      final String? token = await FirebaseService.firebaseMessaging.getToken();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcm_token': token,
      });
      if (societyId.value != 'N/A') {
        DocumentSnapshot<Map<String, dynamic>> society =
            await societies.doc(data['community_id']).get();
        final count = society['members_count'] ?? '';
        membersCount.value = count;
      } else {
        membersCount.value = 0;
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.");
    }
    EasyLoading.dismiss();
  }

  getEditValue() {
    nameC.text = name.value;
    phoneC.text = phone.value;
    rollnoC.text = rollNo.value;
    
  }

  @override
  void onInit() async {
    await getProfile();
    super.onInit();
  }
}
