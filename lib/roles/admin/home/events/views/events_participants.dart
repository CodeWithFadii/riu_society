import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/admin/home/all_users/screens/user_details.dart';
import 'package:riu_society/roles/admin/home/events/controllers/create_event_controller.dart';
import 'package:riu_society/roles/admin/home/all_users/models/user_model.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/list_tile_widget.dart';

class EventsParticipants extends StatelessWidget {
  const EventsParticipants({super.key, required this.eventC});
  final CreateEventController eventC;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Participants',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: eventC.participantList.isNotEmpty
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
                        : '${user.department}👨‍🏫',
                  ),
                );
              }),
            )

          : Center(
              child: Text(
                'No Participants',
                style: AppTextStyle.mediumBlack16,
              ),
            ),
    );
  }
}
