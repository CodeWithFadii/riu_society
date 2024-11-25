import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/community/community_details.dart';
import 'package:riu_society/roles/common/notification/send_method.dart';
import 'package:riu_society/utils/functions.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../../utils/app_colors.dart';

class Communities extends StatelessWidget {
  Communities({super.key, required this.context});
  final BuildContext context;

  final Stream<QuerySnapshot> societies =
      FirebaseFirestore.instance.collection('societies').snapshots();

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    return StreamBuilder<QuerySnapshot>(
      stream: societies,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Expanded(
                child: Center(
                  child: Text(
                    'Please check your internet connection\nand try again!',
                    style: AppTextStyle.regularBlack14,
                  ),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'No Society Created',
                    style: AppTextStyle.regularBlack14,
                  ),
                ),
              );
            }
            final docs = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                itemCount: docs.length,
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () => Get.to(() => CommunityDetails(
                          id: docs[index].id,
                          name: '${docs[index]['name']}'.capitalize!,
                          memberCount: docs[index]['members_count'],
                        )),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            spacing: 7,
                            direction: Axis.vertical,
                            children: [
                              Text(
                                '${docs[index]['name']}'.capitalize!,
                                style: AppTextStyle.boldBlack16,
                              ),
                              Text(
                                '${docs[index]['members_count']} members',
                                style: TextStyle(color: AppColors.grey),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              confirmDefaultDialog(
                                'Delete Society',
                                'Are you sure? If you delete this society, all of the members will have to join another society.',
                                confirm: () async {
                                  deleteMethod(
                                      docs[index].id, docs[index]['name']);
                                },
                              );
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: sizew * 0.070,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
        }
      },
    );
  }

  deleteMethod(String id, String societyName) async {
    try {
      EasyLoading.show();
      QuerySnapshot doc = await FirebaseFirestore.instance
          .collection('societies')
          .doc(id)
          .collection('members')
          .get();
      for (var i in doc.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(i['id'])
            .get()
            .then((value) async {
          SendMethod.sendNotification(
              'Admin deleted $societyName society',
              'If you were the member of this society then be sure to join a new society. Profile>Editprofile>ChooseSociety>Update',
              value['fcm_token']);
          await FirebaseFirestore.instance
              .collection('societies')
              .doc(id)
              .collection('members')
              .doc(i['id'])
              .delete();
        });
      }
      await FirebaseFirestore.instance.collection('notifications').add({
        'time_stamp': DateTime.now(),
        'title': 'Admin deleted $societyName society',
        'description':
            'If you were the member of this society then be sure to join a new society. Profile>Editprofile>ChooseSociety>Update'
      });
      await FirebaseFirestore.instance.collection('societies').doc(id).delete();
      Get.back();
      EasyLoading.dismiss();
    } on Exception {
      EasyLoading.dismiss();
      snackbar('Something went wrong',
          'Error while deleting society please try again or check your internet connection');
    }
  }
}
