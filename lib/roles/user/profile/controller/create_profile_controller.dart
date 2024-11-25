import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:riu_society/roles/common/auth/views/splash_screen.dart';
import 'package:riu_society/roles/common/notification/fcm_service.dart';
import 'package:riu_society/roles/user/dashboard/dashboard.dart';
import 'package:riu_society/utils/functions.dart';

class CreateProfileController extends GetxController {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController rollnoC = TextEditingController();

  Rx<XFile> profileImage = XFile('').obs;
  Rx<XFile> cardImage = XFile('').obs;
  RxMap community = {}.obs;
  RxMap department = {}.obs;
  RxBool student = true.obs;

  getProfileImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      profileImage.value = XFile(img.path);
      return File(img.path);
    }
    return null;
  }

  getCardImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img != null) {
      cardImage.value = XFile(img.path);
      return File(img.path);
    }
    return null;
  }

  Future<dynamic> getQrCode(String id) async {
    final qrValidationResult = QrValidator.validate(
      data: id,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        dataModuleStyle: const QrDataModuleStyle(
          color: Color(0xFF000000),
        ),
        gapless: true,
      );
      Directory tempDir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '${tempDir.path}/$ts.png';
      final picData =
          await painter.toImageData(2048, format: ImageByteFormat.png);
      XFile qrFile = await writeToFile(picData!, path);
      return qrFile;
    } else {
      print(qrValidationResult.error);
    }
  }

  Future<XFile> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    File file = await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return XFile(file.path);
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
    }
    return urls;
  }

  Future<void> createProfile({
    String? fullName,
    Map? department,
    String? phone,
    String? rollno,
    Map? community,
    XFile? image,
    XFile? card,
  }) async {
    if (fullName!.isEmpty ||
        department!.isEmpty ||
        phone!.isEmpty ||
        community!.isEmpty ||
        image!.path.isEmpty ||
        card!.path.isEmpty) {
      snackbar("Warning!", "All of data is required to proceed.");
      return;
    }
    if (student.value) {
      if (rollno!.isEmpty) {
        snackbar("Warning!", "All of data is required to proceed.");
        return;
      }
    }
    try {
      EasyLoading.show();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      XFile qrCode = await getQrCode(currentUser.uid);
      List imageUrls = await uploadImages([image, card, qrCode]);
      final String? token = await FirebaseService.firebaseMessaging.getToken();
      firestore.collection('users').doc(currentUser.uid).set(
        {
          'id': currentUser.uid,
          'role': 'user',
          'status': 'pending',
          'student': student.value,
          'roll_no': student.value ? rollno.toString() : 'n/a',
          'name': fullName.toLowerCase(),
          'phone': phone,
          'email': currentUser.email,
          'department': department['name'],
          'image': imageUrls[0],
          'card': imageUrls[1],
          'qr_code': imageUrls[2],
          'community_id': community['id'],
          'community_name': community['name'],
          'fcm_token': token,
          'events': [],
        },
      ).then((value) async {
        await addToSociety(
          community['id'],
          currentUser.uid,
          fullName,
          imageUrls[0],
          department['name'],
          student.value,
        );
        name = fullName.split(' ').first.capitalize ?? 'there';
        Get.offAll(() => const Dashboard());
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.");
    }
  }

  updateProfile({
    String? fullName,
    String? dep,
    String? phone,
    Map? communityy,
    String? rollno,
    String? image,
    String? imageCard,
    String? societyID,
    String? societyName,
    bool? student,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? imageUrl;
      String? cardUrl;
      if (phone!.isEmpty || fullName!.isEmpty) {
        snackbar("Warning!", "All of data is required to proceed.");
        return;
      }
      if (student!) {
        if (rollno!.isEmpty) {
          snackbar("Warning!", "All of data is required to proceed.");
          return;
        }
      }
      EasyLoading.show();
      //if user selected new image
      if (profileImage.value.path != '') {
        imageUrl = await uploadSingleImage(profileImage.value);
      }
      if (cardImage.value.path != '') {
        cardUrl = await uploadSingleImage(cardImage.value);
      }

      if (currentUser == null) return;
      await firestore.collection('users').doc(currentUser.uid).update(
        {
          'name': fullName.toLowerCase(),
          'phone': phone,
          'department': department.isEmpty ? dep : department['name'],
          'roll_no': student ? rollno : 'n/a',
          'image': profileImage.value.path == '' ? image : imageUrl,
          'card': cardImage.value.path == '' ? imageCard : cardUrl,
          'community_id': community.isEmpty ? societyID : community['id'],
          'community_name': community.isEmpty ? societyName : community['name']
        },
      ).then((value) async {
        //if user changing society then first remove
        //from previous society and update members of previous society
        if (societyID != 'N/A') {
          if (community.isNotEmpty) {
            DocumentSnapshot<Map<String, dynamic>> snapshot =
                await firestore.collection('societies').doc(societyID).get();
            if (snapshot.exists) {
              await firestore
                  .collection('societies')
                  .doc(societyID)
                  .collection('members')
                  .doc(currentUser.uid)
                  .delete()
                  .then((value) async {
                QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
                    .collection('societies')
                    .doc(societyID)
                    .collection('members')
                    .get();
                int count = snapshot.docs.length;
                firestore.collection('societies').doc(societyID).update({
                  'members_count': count,
                });
              });
            }
          }
        }
        await addToSociety(
            community.isEmpty ? societyID : community['id'],
            currentUser.uid,
            fullName,
            profileImage.value.path == '' ? image : imageUrl,
            department.isEmpty ? dep : department['name'],
            student);
        name = fullName.split(' ').first.capitalize ?? 'there';
       
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      snackbar(
          "Something went wrong!", "Something went wrong, please try again.$e");
    }
  }

  uploadSingleImage(XFile image) async {
    if (profileImage.value.path != '' || cardImage.value.path != '') {
      UploadTask? uploadTask;
      final storage = FirebaseStorage.instance.ref();
      final path = 'images/${image.path}';
      final file = File(image.path);
      final ref = storage.child(path);
      uploadTask = ref.putFile(file);
      final snapshot =
          await uploadTask.whenComplete(() => print('Image Uploaded'));
      final url = await snapshot.ref.getDownloadURL();
      return url;
    }
  }

  Future<void> addToSociety(
    String societyId,
    String userId,
    String name,
    String? image,
    String department,
    bool? student,
  ) async {
    try {
      CollectionReference<Map<String, dynamic>> societies =
          FirebaseFirestore.instance.collection('societies');

      societies.doc(societyId).collection('members').doc(userId).set(
        {
          'id': userId,
          'name': name.toLowerCase(),
          'image': image,
          'department': department,
          'student': student
        },
      ).then(
        (value) async {
          QuerySnapshot<Map<String, dynamic>> snapshot =
              await societies.doc(societyId).collection('members').get();
          int count = snapshot.docs.length;
          societies.doc(societyId).update(
            {
              'members_count': count,
            },
          );
        },
      );
    } on FirebaseException catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }
}
