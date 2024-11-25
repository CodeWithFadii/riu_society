import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/tasks/controllers/task_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/functions.dart';

class SubAdminTasks extends StatelessWidget {
  SubAdminTasks({super.key});
  final TaskController taskC = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(
          'Tasks',
          style: AppTextStyle.mediumBlack20.copyWith(color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: taskC.subAdminTasks(),
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
                            'No Task Found',
                            style: AppTextStyle.regularBlack14,
                          ),
                        ),
                      );
                    }
                }
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            top: 14, left: 14, right: 14, bottom: 14),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(
                                  3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(doc['image']),
                                      onBackgroundImageError:
                                          (object, stackTrace) {
                                        const Icon(Icons.man);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 14,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //name
                                          '${doc['name']}'.capitalize!,
                                          style: AppTextStyle.mediumBlack14,
                                        ),
                                        Text(
                                          //communityName
                                          doc['department'],
                                          style: AppTextStyle.regularBlack12
                                              .copyWith(color: AppColors.grey),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Checkbox(
                                      value: doc['pending'],
                                      onChanged: (value) {
                                        if (doc['pending']) {
                                          confirmDefaultDialog('Undo Task',
                                              'Are you sure? Do you want to mark this task as unCompleted.',
                                              confirm: () async {
                                            await pendingTask(doc.id);
                                            Get.back();
                                          });
                                        } else {
                                          confirmDefaultDialog('Complete Task',
                                              'Are you sure? Do you want to mark this task as completed.',
                                              confirm: () async {
                                            await completeTask(doc.id);
                                            Get.back();
                                          });
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5)
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Task Description : ',
                                  style: AppTextStyle.boldBlack14,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${doc['description']}'.capitalize!,
                                  style: AppTextStyle.regularBlack14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  completeTask(String id) {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(id)
        .update({'pending': true});
  }

  pendingTask(String id) {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(id)
        .update({'pending': false});
  }
}
