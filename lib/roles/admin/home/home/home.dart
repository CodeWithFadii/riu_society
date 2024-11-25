import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/community/create_community.dart';
import 'package:riu_society/roles/admin/home/events/views/create_event.dart';
import 'package:riu_society/roles/admin/home/events/views/events.dart';
import 'package:riu_society/roles/admin/home/home/drawer_widget.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../community/communities.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  DateTime? lastPressedAt;
  bool events = true;
  bool admin = true;
  int taskCount = 0;
  int notificationLength = 0;
  late SharedPreferences pref;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot? doc;
  getRole() async {
    doc =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    doc!['role'] == 'sub-admin'
        ? setState(() {
            admin = false;
          })
        : setState(() {
            admin = true;
          });
    if (!admin) {
      getTasks();
    }
  }

  getTasks() async {
    final data = await FirebaseFirestore.instance
        .collection('tasks')
        .where('id', isEqualTo: userUid)
        .where('pending', isEqualTo: false)
        .get();
    setState(() {
      taskCount = data.docs.length;
    });
  }

  getNotifications() async {
    final data =
        await FirebaseFirestore.instance.collection('notifications').get();
    setState(() {
      notificationLength = data.docs.length;
    });
  }

  getPref() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getRole();
    getPref();
    getNotifications();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    final sizeh = MediaQuery.of(context).size.height * 1;
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressedAt == null ||
            now.difference(lastPressedAt!) > const Duration(seconds: 4)) {
          // Show a snackbar indicating that the user should tap again to exit
          rawSackbar('Tap again to exit');
          lastPressedAt = now;
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: admin
            ? DrawerAdmin()
            : DrawerSubAdmin(
                doc: doc!,
                taskCount: taskCount,
                notificationLength: notificationLength,
                pref: pref,
              ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: sizew * 0.040),
                height: sizeh * 0.30,
                width: double.infinity,
                color: AppColors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            scaffoldKey.currentState!.openDrawer();
                          },
                          child: const Icon(
                            Icons.list,
                            size: 32,
                            color: AppColors.white,
                          ),
                        ),
                        Image.asset(
                          'assets/images/rs_logo_white.png',
                          height: sizew * 0.10,
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    Container(
                      height: 53,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (() {
                                if (admin) {
                                  setState(() {
                                    events = true;
                                  });
                                }
                              }),
                              child: Container(
                                alignment: Alignment.center,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: events
                                        ? AppColors.black
                                        : AppColors.white),
                                child: Text('Events',
                                    style: events
                                        ? AppTextStyle.regularWhite14
                                        : AppTextStyle.regularBlack14),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (() {
                                admin
                                    ? setState(() {
                                        events = false;
                                      })
                                    : rawSackbar('Permission not given');
                              }),
                              child: Container(
                                alignment: Alignment.center,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: events
                                        ? AppColors.white
                                        : AppColors.black),
                                padding: EdgeInsets.symmetric(
                                  horizontal: sizew * 0.08,
                                ),
                                child: Text('Societies',
                                    style: events
                                        ? AppTextStyle.regularBlack14
                                        : AppTextStyle.regularWhite14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          events ? 'Create New Event' : 'Create New Society',
                          style: AppTextStyle.regularWhite18,
                        ),
                        GestureDetector(
                          onTap: (() {
                            admin
                                ? events
                                    ? Get.to(() => CreateEvent())
                                    : Get.dialog(createCummunityWidget(context))
                                : rawSackbar('Permission not given');
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                    BorderRadius.circular(sizew * 0.025)),
                            padding: EdgeInsets.symmetric(
                                horizontal: sizew * 0.034,
                                vertical: sizeh * 0.011),
                            child: Icon(
                              events ? Iconsax.calendar_add : Iconsax.add,
                              color: AppColors.black,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              events ? eventsWidget(context) : Communities(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
