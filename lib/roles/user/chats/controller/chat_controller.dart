import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/user/chats/views/chat_screen.dart';
import 'package:riu_society/utils/functions.dart';

class ChatController extends GetxController {
  final TextEditingController messageC = TextEditingController();
  String friendImage = '';
  String friendDepartment = '';
  final userID = FirebaseAuth.instance.currentUser!.uid;
  RxString userName = ''.obs;
  CollectionReference ref = FirebaseFirestore.instance.collection('chats');
  RxString chatID = ''.obs;

  getChatID(String friendId, String friend) {
    try {
      EasyLoading.show();
      ref
          .where('users', isEqualTo: {userID: null, friendId: null})
          .limit(1)
          .get()
          .then(
            (value) async {
              if (value.docs.isNotEmpty) {
                chatID.value = value.docs.first.id;
                Get.to(() => ChatScreen(
                      friendName: friend,
                      friendId: friendId,
                      userName: userName,
                    ));
                EasyLoading.dismiss();
              } else {
                DocumentSnapshot doc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .get();
                await ref.add({
                  'users': {userID: null, friendId: null},
                  'users_array': [userID, friendId],
                  'user_Id': userID,
                  'friend_Id': friendId,
                  'user_name': doc['name'],
                  'friend_name': friend,
                  'user_image': doc['image'],
                  'friend_image': friendImage,
                  'user_department': doc['department'],
                  'friend_department': friendDepartment,
                  'last_msg': '',
                }).then((value) {
                  chatID.value = value.id;
                  EasyLoading.dismiss();
                  Get.to(() => ChatScreen(
                        friendName: friend,
                        friendId: friendId,
                        userName: userName,
                      ));
                });
              }
            },
          );
    } on Exception {
      EasyLoading.dismiss();
      snackbar('error', 'Check your internet connection or try again');
    }
  }

  sendMessage(String msg) {
    if (msg.trim().isNotEmpty) {
      ref.doc(chatID.value).update({
        'createdAT': DateTime.now(),
        'last_msg': msg,
      });
      ref.doc(chatID.value).collection('messages').doc().set({
        'createdAT': DateTime.now(),
        'msg': msg,
        'uid': userID,
      }).then((value) {
        messageC.clear();
      });
    }
  }

  getMessages(String id) {
    if (id.isNotEmpty) {
      var data = FirebaseFirestore.instance
          .collection('chats')
          .doc(id)
          .collection('messages')
          .orderBy('createdAT', descending: true)
          .snapshots();
      return data;
    }
  }

  Future getArguments(String image, String department) async {
    friendImage = image;
    friendDepartment = department;
  }

  getInitialData() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    userName.value = doc['name'];
  }

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }
}
