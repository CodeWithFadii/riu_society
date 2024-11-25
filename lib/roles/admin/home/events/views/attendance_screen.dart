import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/all_users/models/user_model.dart';
import 'package:riu_society/roles/admin/home/all_users/screens/user_details.dart';
import 'package:riu_society/roles/admin/home/events/controllers/create_event_controller.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/list_tile_widget.dart';

import 'scan_qrcode.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen(
      {super.key, required this.eventC, required this.docID});
  final CreateEventController eventC;
  final String docID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Attendance',
            style: AppTextStyle.regularWhite18,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => ScanQrCode(
                      eventC: eventC,
                      docID: docID,
                    ));
              },
              child: const Icon(
                Icons.qr_code_scanner,
                size: 25,
              ),
            ),
            const SizedBox(width: 18)
          ],
        ),
        body: Obx(
          () {
            return eventC.participantList.isNotEmpty
                ? ListView.builder(
                    itemCount: eventC.participantList.length,
                    itemBuilder: ((context, index) {
                      UserModel user = eventC.participantList[index];
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
                              return UserDetailsWidget(
                                user: user,
                                isParticipant: true,
                              );
                            },
                          );
                        },
                        child: ListTileWidget(
                          name: '${user.name}'.capitalize,
                          image: user.image,
                          department: user.student!
                              ? '${user.department}👨‍🎓 '
                              : '${user.department}👨‍🏫 ',
                        ),
                      );
                    }),
                  )
                : Center(
                    child: Text(
                      'No Attendance Taken Yet',
                      style: AppTextStyle.mediumBlack16,
                    ),
                  );
          },
        ));
  }
}
