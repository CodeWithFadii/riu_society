import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/events/controllers/create_event_controller.dart';
import 'package:riu_society/roles/admin/home/events/models/event_model.dart';
import 'package:riu_society/roles/admin/home/events/views/attendance_screen.dart';
import 'package:riu_society/roles/admin/home/events/views/edit_event.dart';
import 'package:riu_society/roles/admin/home/events/views/events_participants.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/material_button.dart';

class EventDetails extends StatelessWidget {
  EventDetails({super.key, required this.event});
  final EventModel event;
  final CreateEventController eventC = Get.put(CreateEventController());
  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    final sizeh = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        actions: [
          GestureDetector(
            onTap: () {
              eventC.passArguments(event);
              Get.to(() => EditEvent(
                    event: event,
                  ));
            },
            child: const Icon(
              Icons.edit,
              size: 25,
            ),
          ),
          const SizedBox(width: 18)
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Event Detail',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  child: Container(
                    width: double.infinity,
                    height: sizeh * 0.3,
                    color: AppColors.lightGrey,
                    child: Image.network(
                      event.image ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: sizeh * 0.010,
                      ),
                      Wrap(
                        spacing: 11,
                        direction: Axis.vertical,
                        children: [
                          Text(
                            event.title ?? '',
                            style: AppTextStyle.boldBlack18,
                          ),
                          Wrap(
                            spacing: 15,
                            children: [
                              Wrap(
                                spacing: 10,
                                children: [
                                  const Icon(
                                    Iconsax.calendar_add,
                                  ),
                                  Text(
                                    event.date ?? '',
                                    style: AppTextStyle.regularBlack16,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5),
                              Text(
                                event.fee!.isEmpty
                                    ? 'Free'
                                    : 'Rs. ${event.fee}',
                                style: AppTextStyle.regularBlack16,
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 10,
                            children: [
                              const Icon(
                                Iconsax.location,
                              ),
                              SizedBox(
                                width: sizew * 0.8,
                                child: Text(
                                  '${event.address} (${event.city}) ',
                                  style: AppTextStyle.regularBlack16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Description (${event.communityName})',
                            style: AppTextStyle.boldBlack18,
                          ),
                          SizedBox(
                            width: sizew * 0.89,
                            child: Text(
                              event.description ?? '',
                              style: AppTextStyle.regularBlack16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      MaterialButtonWidget(
                        onPressed: () async {
                          await eventC.getParticipants(event.id!);
                          Get.to(() => EventsParticipants(
                                eventC: eventC,
                              ));
                        },
                        height: 50,
                        width: double.infinity,
                        text: Text(
                          'View Attendies',
                          style: AppTextStyle.regularWhite16,
                        ),
                        color: AppColors.black,
                      ),
                      const SizedBox(height: 15),
                      MaterialButtonWidget(
                        onPressed: () async {
                          await eventC.markAttendance(event.id!);
                          Get.to(() => AttendanceScreen(
                                eventC: eventC,
                                docID: event.id!,
                              ));
                        },
                        height: 50,
                        width: double.infinity,
                        text: Text(
                          'View Attendance',
                          style: AppTextStyle.regularWhite16,
                        ),
                        color: AppColors.black,
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
