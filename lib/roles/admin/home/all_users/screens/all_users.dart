import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/all_users/models/user_model.dart';
import 'package:riu_society/roles/admin/home/all_users/screens/user_details.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/widgets/changeabletabbar.dart';
import 'package:riu_society/utils/widgets/list_tile_widget.dart';
import '../../../../../utils/app_textstyle.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  bool approved = true;

  final Stream<QuerySnapshot> pending = FirebaseFirestore.instance
      .collection('users')
      .where('status', isEqualTo: 'pending')
      .snapshots();
  late Stream<QuerySnapshot> approve = FirebaseFirestore.instance
      .collection('users')
      .where('status', isEqualTo: 'approved')
      .snapshots();
  List<String> dataList = ['Remove', 'Make sub-admin'];

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    final sizeh = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'All Users',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: sizew * 0.040),
            color: AppColors.black,
            height: sizeh * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChangeAbleTabar(
                    firstText: 'Approved',
                    secondText: 'Pending',
                    firstOnTap: (() {
                      setState(() {
                        approved = true;
                      });
                    }),
                    secondOnTap: (() {
                      setState(() {
                        approved = false;
                      });
                    }),
                    value: approved),
              ],
            ),
          ),
          approved
              ? StreamBuilder<QuerySnapshot>(
                  stream: approve,
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
                                'No User Found',
                                style: AppTextStyle.regularBlack14,
                              ),
                            ),
                          );
                        }
                        final docs = snapshot.data!.docs;
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            itemCount: docs.length,
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
                                            rollno: docs['roll_no'],
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
                                      ? '${docs['department']}👨‍🎓 '
                                      : '${docs['department']}👨‍🏫 ',
                                  image: docs['image'],
                                ),
                              );
                            }),
                          ),
                        );
                    }
                  },
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: pending,
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
                                'No User Found',
                                style: AppTextStyle.regularBlack14,
                              ),
                            ),
                          );
                        }
                        final docs = snapshot.data!.docs;
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            itemCount: docs.length,
                            itemBuilder: ((context, index) {
                              var docs = snapshot.data!.docs[index];
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
                                            fcmToken: docs['fcm_token'],
                                            name: docs['name'],
                                            department: docs['department'],
                                            community: docs['community_name'],
                                            phoneNo: docs['phone'],
                                            cardImage: docs['card'],
                                            image: docs['image'],
                                            student: docs['student'],
                                            rollno: docs['roll_no'],
                                            id: docs.id);
                                        return UserDetailsWidget(
                                          user: user,
                                          isParticipant: false,
                                        );
                                      });
                                },
                                child: ListTileWidget(
                                  name: docs['name'].toString().capitalize,
                                  department: docs['student']
                                      ? '${docs['department']}👨‍🎓 '
                                      : '${docs['department']}👨‍🏫',
                                  image: docs['image'],
                                  trailing: Icon(
                                    Iconsax.more_square,
                                    color: AppColors.black,
                                    size: sizew * 0.07,
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                    }
                  },
                )
        ],
      ),
    );
  }
}
