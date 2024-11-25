import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/all_users/models/user_model.dart';
import 'package:riu_society/roles/admin/home/all_users/screens/user_details.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/list_tile_widget.dart';

class SubAdmins extends StatelessWidget {
  SubAdmins({super.key});

  final Stream<QuerySnapshot> subAdmin = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'sub-admin')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Sub Admins',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: subAdmin,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(
                      child: SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
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
                          'No Sub-Admin Found',
                          style: AppTextStyle.regularBlack14,
                        ),
                      ),
                    );
                  }
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                  itemBuilder: ((context, index) {
                    final docs = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            context: context,
                            builder: (BuildContext context) {
                              UserModel user = UserModel(
                                  email: docs['email'],
                                  name: docs['name'],
                                  department: docs['department'],
                                  community: docs['community_name'],
                                  phoneNo: docs['phone'],
                                  cardImage: docs['card'],
                                  image: docs['image'],
                                  student: docs['student'],
                                  rollno: docs['roll_no'].toString(),
                                  id: docs.id);
                              return UserDetailsWidget(
                                user: user,
                                isParticipant: true,
                              );
                            });
                      },
                      child: ListTileWidget(
                        name: docs['name'].toString().capitalize,
                        department: docs['student']
                            ? '${docs['department']}👨‍🎓'
                            : '${docs['department']}👨‍🏫',
                        image: docs['image'],
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_horiz_outlined),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                value: 'Remove',
                                child: Text(
                                  'Remove',
                                  style: AppTextStyle.mediumBlack16,
                                ),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            confirmDefaultDialog(
                              'Remove Sub-Admin',
                              'Are you sure? If you remove this sub-admin, this user will be considered as a normal user.',
                              confirm: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(docs.id)
                                    .update({'role': 'user'}).then(
                                  (value) {
                                    Get.back();
                                    return rawSackbar(
                                        'You removed ${docs['name']} as Sub-admin'
                                            .capitalize!);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
