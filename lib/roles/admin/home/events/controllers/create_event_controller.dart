import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riu_society/roles/admin/home/events/models/event_model.dart';
import 'package:riu_society/roles/admin/home/all_users/models/user_model.dart';
import 'package:riu_society/roles/admin/home/home/home.dart';
import 'package:riu_society/utils/functions.dart';

class CreateEventController extends GetxController {
  RxList<UserModel> participantList = <UserModel>[].obs;
  Rx<TextEditingController> dateC = TextEditingController().obs;
  Rx<TextEditingController> locationC = TextEditingController().obs;
  Rx<TextEditingController> cityC = TextEditingController().obs;
  Rx<TextEditingController> titleC = TextEditingController().obs;
  Rx<TextEditingController> descriptionC = TextEditingController().obs;
  Rx<TextEditingController> priceC = TextEditingController().obs;
  RxString communityName = ''.obs;
  Rx<XFile> image = XFile('').obs;
  RxMap community = {}.obs;

  getImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      image.value = XFile(img.path);
      return File(img.path);
    }
    return null;
  }

  getPicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2029),
    ).then(
      (value) {
        dateC.value.text = formatDate(value.toString());
      },
    );
  }

  Future<List> uploadImages(List<XFile> images) async {
    UploadTask? uploadTask;
    List urls = [];
    final storage = FirebaseStorage.instance.ref();
    for (XFile image in images) {
      final path = 'images/${image.name}';
      final file = File(image.path);
      final ref = storage.child(path);
      uploadTask = ref.putFile(file);
      final snapshot =
          await uploadTask.whenComplete(() => print('Image Uploaded'));
      final downloadUrl = await snapshot.ref.getDownloadURL();
      urls.add(downloadUrl);
      print('image uploaded');
    }
    return urls;
  }

  Future<void> createEvent({
    String? date,
    String? location,
    String? title,
    String? description,
    String? city,
    String? fee,
    XFile? image,
  }) async {
    if (date!.isEmpty ||
        location!.isEmpty ||
        title!.isEmpty ||
        description!.isEmpty ||
        city!.isEmpty ||
        community.isEmpty ||
        image!.path.isEmpty) {
      snackbar("Warning!", "All of data is required to proceed.");
      return;
    }
    try {
      EasyLoading.show();
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      List imageUrls = await uploadImages([image]);
      firestore.collection('events').add(
        {
          'image': imageUrls[0],
          'community_id': community['id'],
          'community_name': community['name'],
          'date': date,
          'location': location,
          'title': title,
          'city': city.capitalize,
          'description': description,
          'fee': fee,
          'time_stamp': DateTime.now(),
          'participants': [],
          'attendance': []
        },
      ).then((value) async {
        Get.back();
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.");
    }
  }

  Future<void> editEvent(
      {String? date,
      String? location,
      String? title,
      String? description,
      String? fee,
      String? networkImage,
      String? city,
      String? communityName,
      String? communityId,
      String? docID}) async {
    try {
      EasyLoading.show();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List? imageUrls;
      if (image.value.path != '') {
        imageUrls = await uploadImages([image.value]);
      }
      firestore.collection('events').doc(docID).update(
        {
          'image': image.value.path == '' ? networkImage : imageUrls![0],
          'date': date,
          'location': location,
          'city': '$city'.capitalize,
          'title': title,
          'description': description,
          'fee': fee,
          'community_id': community.isEmpty ? communityId : community['id'],
          'community_name':
              community.isEmpty ? communityName : community['name']
        },
      ).then((value) async {
        dateC.value.clear();
        locationC.value.clear();
        cityC.value.clear();
        titleC.value.clear();
        descriptionC.value.clear();
        priceC.value.clear();
        image.value = XFile('');
        Get.offAll(() => const AdminHome());
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.");
    }
  }

  passArguments(EventModel event) {
    dateC.value.text = event.date!;
    locationC.value.text = event.address!;
    titleC.value.text = event.title!;
    descriptionC.value.text = event.description!;
    priceC.value.text = event.fee!;
    cityC.value.text = event.city!;
    communityName.value = event.communityName!;
  }

  getParticipants(String docID) async {
    try {
      participantList.clear();
      EasyLoading.show();
      DocumentSnapshot docs = await FirebaseFirestore.instance
          .collection('events')
          .doc(docID)
          .get();
      List userIds = List.from(docs['participants']);
      for (var i in userIds) {
        DocumentSnapshot docs =
            await FirebaseFirestore.instance.collection('users').doc(i).get();
        participantList.add(UserModel(
            email: docs['email'],
            name: docs['name'],
            department: docs['department'],
            community: docs['community_name'],
            phoneNo: docs['phone'],
            cardImage: docs['card'],
            image: docs['image'],
            student: docs['student'],
            rollno: docs['roll_no'],
            id: docs.id));
      }
      EasyLoading.dismiss();
    } on Exception {
      EasyLoading.dismiss();
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.");
    }
  }

  addAttendance(
      String docID, String getdata, bool mounted, BuildContext context) async {
    try {
      EasyLoading.show();
      await FirebaseFirestore.instance.collection('events').doc(docID).update(
        {
          'attendance': FieldValue.arrayUnion([getdata])
        },
      ).then((value) async {
        DocumentSnapshot docs = await FirebaseFirestore.instance
            .collection('users')
            .doc(getdata)
            .get();
        participantList.add(UserModel(
            email: docs['email'],
            name: docs['name'],
            department: docs['department'],
            community: docs['community_name'],
            phoneNo: docs['phone'],
            cardImage: docs['card'],
            image: docs['image'],
            student: docs['student'],
            rollno: docs['roll_no'].toString(),
            id: docs.id));
        if (mounted) {
          Navigator.pop(context);
        }
        EasyLoading.dismiss();
      });
    } on Exception {
      EasyLoading.dismiss();
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.");
    }
  }

  markAttendance(String docID) async {
    try {
      participantList.clear();
      EasyLoading.show();
      DocumentSnapshot docs = await FirebaseFirestore.instance
          .collection('events')
          .doc(docID)
          .get();
      List userIds = List.from(docs['attendance']);
      for (var i in userIds) {
        DocumentSnapshot docs =
            await FirebaseFirestore.instance.collection('users').doc(i).get();
        participantList.add(UserModel(
            email: docs['email'],
            name: docs['name'],
            department: docs['department'],
            community: docs['community_name'],
            phoneNo: docs['phone'],
            cardImage: docs['card'],
            image: docs['image'],
            student: docs['student'],
            rollno: docs['roll_no'],
            id: docs.id));
      }
      EasyLoading.dismiss();
    } on Exception {
      EasyLoading.dismiss();
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.");
    }
  }
}
