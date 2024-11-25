import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riu_society/roles/admin/home/Budget/controller/budget_controller.dart';
import 'package:riu_society/roles/admin/home/Budget/screens/add_event.dart';
import 'package:riu_society/roles/admin/home/Budget/screens/manage_budget.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/functions.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({super.key});
  final BudgetController budgetC = Get.put(BudgetController());

  final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('budget')
      .orderBy('time_stamp', descending: true)
      .snapshots();
  final optionsList = ['edit,delete'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'Budget Planning',
          style: AppTextStyle.mediumBlack18.copyWith(
            color: AppColors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(addEvent(budgetC));
            },
            icon: const Icon(Iconsax.add_square4, size: 25),
          )
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
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
                        return Center(
                          child: Text(
                            'Please check your internet connection\nand try again!',
                            style: AppTextStyle.regularBlack14,
                          ),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No Events Created',
                            style: AppTextStyle.regularBlack14,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Card(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => ManageBudget(
                                        docID: doc.id,
                                        budgetC: budgetC,
                                        eventName:
                                            '${doc['event_title']}'.capitalize!,
                                      ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${doc['event_title']}'.capitalize!,
                                          style: AppTextStyle.mediumBlack16,
                                        ),
                                      ),
                                      
                                      GestureDetector(
                                        onTap: () async {
                                          confirmDefaultDialog('Delete Event',
                                              'Are you sure? If you delete this event, all of the entities will be deleted related to this.',
                                              confirm: () async {
                                            await budgetC.deleteEvent(doc.id);
                                            Get.back();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
