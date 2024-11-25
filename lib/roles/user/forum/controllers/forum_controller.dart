import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riu_society/utils/functions.dart';
import '../model/forum_model.dart';

class ForumController extends GetxController {
  RxInt sortIndex = 0.obs;
  RxString searchedForum = ''.obs;
  RxList<ForumModel> popularList = <ForumModel>[].obs;
  final TextEditingController notWorking = TextEditingController();
  Rx<TextEditingController> searchC = TextEditingController().obs;
  final TextEditingController descriptionC = TextEditingController();
  final TextEditingController titleC = TextEditingController();
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> docForum =
      FirebaseFirestore.instance.collection('forums');

  createForum(String? description, String? title) async {
    try {
      if (description!.isEmpty || title!.isEmpty) {
        return snackbar('Error', 'Enter All required Data');
      }
      EasyLoading.show();
      final userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userData =
          await firebaseFirestore.collection('users').doc(userId).get();
      final name = await userData.data()?['name'];
      final community = await userData.data()?['community_name'];
      final image = await userData.data()?['image'];
      await firebaseFirestore.collection('forums').add({
        'time_stamp': DateTime.now(),
        'user_id': userId,
        'title': title,
        'description': description,
        'name': name,
        'community_name': community,
        'image': image,
        'likes': [],
        'dislikes': []
      }).then((value) async {
        EasyLoading.dismiss();
        descriptionC.clear();
        titleC.clear();
      });
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Error',
          'Error While Createing Forum, Check your internet connection or try again');
    }
  }

  createAdminForum(String? description, String? title) async {
    try {
      if (description!.isEmpty || title!.isEmpty) {
        return snackbar('Error', 'Enter All required Data');
      }
      EasyLoading.show();
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await firebaseFirestore.collection('forums').add({
        'time_stamp': DateTime.now(),
        'user_id': userId,
        'title': title,
        'description': description,
        'name': 'Admin',
        'community_name': 'none',
        'image': '',
        'likes': [],
        'dislikes': []
      }).then((value) async {
        EasyLoading.dismiss();
        descriptionC.clear();
        titleC.clear();
      });
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Error',
          'Error While Createing Forum, Check your internet connection or try again');
    }
  }

  getAllPosts() {
    return FirebaseFirestore.instance
        .collection('forums')
        .orderBy('time_stamp', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ForumModel.fromFireStore(e)).toList());
  }

  getMyPosts() {
    return FirebaseFirestore.instance
        .collection('forums')
        .where('user_id', isEqualTo: userUid)
        .orderBy('time_stamp', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ForumModel.fromFireStore(e)).toList());
  }

  sortPosts() async {
    EasyLoading.show();
    popularList.clear();
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('forums')
        .orderBy('time_stamp', descending: true)
        .get();
    for (var i in snap.docs) {
      popularList.add(ForumModel.fromFireStore(i));
    }
    sortList(popularList);
    EasyLoading.dismiss();
  }

  sortList(RxList<ForumModel> popularList) {
    popularList.sort(((a, b) => b.likes.length.compareTo(a.likes.length)));
  }

  searchedPosts() {
    return searchedForum.isEmpty
        ? FirebaseFirestore.instance
            .collection('forums')
            .orderBy('time_stamp', descending: true)
            .snapshots()
            .map((event) =>
                event.docs.map((e) => ForumModel.fromFireStore(e)).toList())
        : FirebaseFirestore.instance
            .collection('forums')
            .where('community_name',
                isGreaterThanOrEqualTo: searchedForum.value.capitalize)
            .snapshots()
            .map((event) =>
                event.docs.map((e) => ForumModel.fromFireStore(e)).toList());
  }

  handelLikes(ForumModel post) {
    if (post.likes.contains(userUid)) {
      docForum.doc(post.id).update({
        'likes': FieldValue.arrayRemove([userUid])
      });
    } else if (post.dislikes.contains(userUid)) {
      docForum.doc(post.id).update({
        'dislikes': FieldValue.arrayRemove([userUid])
      });
      docForum.doc(post.id).update({
        'likes': FieldValue.arrayUnion([userUid])
      });
    } else {
      docForum.doc(post.id).update({
        'likes': FieldValue.arrayUnion([userUid])
      });
    }
  }

  handelDisLikes(ForumModel post) {
    if (post.dislikes.contains(userUid)) {
      docForum.doc(post.id).update({
        'dislikes': FieldValue.arrayRemove([userUid])
      });
    } else if (post.likes.contains(userUid)) {
      docForum.doc(post.id).update({
        'likes': FieldValue.arrayRemove([userUid])
      });
      docForum.doc(post.id).update({
        'dislikes': FieldValue.arrayUnion([userUid])
      });
    } else {
      docForum.doc(post.id).update({
        'dislikes': FieldValue.arrayUnion([userUid])
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    sortPosts();
    searchC.value.addListener(() {
      searchedForum.value = searchC.value.text;
    });
  }
}
