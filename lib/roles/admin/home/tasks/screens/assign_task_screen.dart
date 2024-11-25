import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/tasks/controllers/task_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/list_tile_widget.dart';
import 'package:riu_society/utils/widgets/material_button.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({
    super.key,
    required this.taskC,
  });
  final TaskController taskC;

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        height: 500,
        child: Column(
          children: [
            Text(
              'Assign Task',
              style: AppTextStyle.boldBlack20,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.lightGrey,
              ),
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                autofocus: false,
                maxLines: null,
                controller: widget.taskC.descriptionC,
                style: const TextStyle(fontSize: 16, color: AppColors.primary),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description ...',
                  hintStyle: AppTextStyle.regularBlack16
                      .copyWith(color: AppColors.grey),
                ),
              ),
            ),
            widget.taskC.adminList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.taskC.adminList.length,
                      itemBuilder: (context, index) {
                        SubAdminModel admin = widget.taskC.adminList[index];
                        return ListTileWidget(
                          //name
                          name: '${admin.name}'.capitalize,
                          //department
                          department: admin.department,
                          //image
                          image: admin.image,
                          //checkbox
                          trailing: Obx(
                            () => Checkbox(
                              value: widget.taskC.adminList[index].selected,
                              onChanged: (value) {
                                setState(() {
                                  widget.taskC.adminList[index].selected =
                                      value;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                        child: Text(
                    'No Admin Found',
                    style: AppTextStyle.mediumBlack16,
                  ))),
            const SizedBox(height: 10),
            MaterialButtonWidget(
              onPressed: () async {
                widget.taskC.assignTask();
              },
              height: 50,
              width: double.infinity,
              text: Text(
                'Assign Task',
                style: AppTextStyle.regularWhite16,
              ),
              color: AppColors.black,
            )
          ],
        ),
      ),
    );
  }
}
