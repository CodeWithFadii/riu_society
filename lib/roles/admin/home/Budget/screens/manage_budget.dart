import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/Budget/controller/budget_controller.dart';
import 'package:riu_society/roles/admin/home/Budget/model/entity_modal.dart';
import 'package:riu_society/roles/admin/home/Budget/screens/budget_dialog.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';

class ManageBudget extends StatelessWidget {
  ManageBudget(
      {super.key,
      required this.docID,
      required this.budgetC,
      required this.eventName});
  final String docID;
  final BudgetController budgetC;
  final String eventName;
  final optionsList = ['Edit', 'Delete'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              budgetC.titleC.clear();
              budgetC.priceC.clear();
              Get.dialog(entityDialog(budgetC, docID));
            },
            icon: const Icon(Iconsax.add_square4, size: 25),
          )
        ],
        title: Text(
          //event name
          eventName,
          style: AppTextStyle.mediumBlack18.copyWith(
            color: AppColors.white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<List<EntityModal>>(
          stream: budgetC.getEntities(docID),
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
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No Entities Created',
                      style: AppTextStyle.regularBlack14,
                    ),
                  );
                }
            }
            //getting total
            int total = 0;
            for (var element in snapshot.data!) {
              total += element.price;
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final doc = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    doc.title.capitalize!,
                                    style: AppTextStyle.mediumBlack16,
                                  ),
                                ),
                                Text(
                                  'Rs. ${doc.price}',
                                  style: AppTextStyle.regularBlack16
                                      .copyWith(color: AppColors.grey),
                                ),
                                const SizedBox(width: 30),
                                PopupMenuButton(
                                  icon: const Icon(Icons.more_vert_outlined),
                                  itemBuilder: (BuildContext context) {
                                    return optionsList.map(
                                      (e) {
                                        return PopupMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: AppTextStyle.mediumBlack16,
                                          ),
                                        );
                                      },
                                    ).toList();
                                  },
                                  onSelected: (value) {
                                    if (value == optionsList[0]) {
                                      budgetC.titleC.text = doc.title;
                                      budgetC.priceC.text =
                                          doc.price.toString();
                                      Get.dialog(entityDialog(budgetC, docID,
                                          edit: true,entityId: doc.id));
                                    } else {
                                      budgetC.deleteEntity(docID, doc.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total :  ',
                        style: AppTextStyle.boldBlack18,
                      ),
                      Text(
                        'Rs. $total',
                        style: AppTextStyle.regularBlack16,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
