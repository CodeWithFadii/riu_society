import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/admin/home/events/controllers/create_event_controller.dart';
import 'package:riu_society/roles/common/notification/send_method.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/material_button.dart';
import 'package:riu_society/utils/widgets/select_community.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

// ignore: must_be_immutable
class CreateEvent extends StatelessWidget {
  CreateEvent({super.key});
  final CreateEventController eventC = Get.put(CreateEventController());

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).requestFocus(FocusNode());
      }),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Create Event',
            style: AppTextStyle.regularWhite18,
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: SingleChildScrollView(
              child: Obx(() {
                return Column(
                  children: [
                    const SizedBox(
                      height: 14,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: (() async {
                          await eventC.getImage();
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 162,
                          color: AppColors.lightGrey,
                          child: eventC.image.value.path == ''
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_search_outlined,
                                      color: AppColors.grey,
                                      size: sizew * 0.12,
                                    ),
                                    Text('Select Image',
                                        style: AppTextStyle.regularBlack18
                                            .copyWith(color: AppColors.grey)),
                                  ],
                                )
                              : Image.file(
                                  File(eventC.image.value.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SimpleTextField(
                      readOnly: true,
                      borderRadius: 10,
                      controller: eventC.dateC.value,
                      width: double.infinity,
                      hint: 'Select Date',
                      trailing: Iconsax.calendar_add,
                      onTrailingTap: () {
                        eventC.getPicker(context);
                      },
                      hintstyle: AppTextStyle.regularBlack16.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return SelectSociety(eventSide: true,eventC: eventC,);
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        width: sizew,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          eventC.community.isNotEmpty
                              ? eventC.community['name'].toString().capitalize!
                              : 'Tap to Select Society*',
                          style: AppTextStyle.regularBlack16.copyWith(
                            color: eventC.community.isNotEmpty
                                ? AppColors.black
                                : AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.lightGrey,
                      ),
                      constraints:
                          const BoxConstraints(minHeight: 80, maxHeight: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        autofocus: false,
                        maxLines: null,
                        controller: eventC.locationC.value,
                        style: const TextStyle(
                            fontSize: 16, color: AppColors.primary),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Location',
                          hintStyle: AppTextStyle.regularBlack16
                              .copyWith(color: AppColors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SimpleTextField(
                      borderRadius: 10,
                      controller: eventC.cityC.value,
                      width: double.infinity,
                      hint: 'City Name',
                      hintstyle: AppTextStyle.regularBlack16.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SimpleTextField(
                      borderRadius: 10,
                      controller: eventC.titleC.value,
                      width: double.infinity,
                      hint: 'Event Title',
                      hintstyle: AppTextStyle.regularBlack16.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.lightGrey,
                      ),
                      constraints:
                          const BoxConstraints(minHeight: 120, maxHeight: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        autofocus: false,
                        maxLines: null,
                        controller: eventC.descriptionC.value,
                        style: const TextStyle(
                            fontSize: 16, color: AppColors.primary),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description',
                          hintStyle: AppTextStyle.regularBlack16
                              .copyWith(color: AppColors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SimpleTextField(
                      borderRadius: 10,
                      controller: eventC.priceC.value,
                      width: double.infinity,
                      hint: 'Entry Fee  (optional)',
                      hintstyle: AppTextStyle.regularBlack16.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 25),
                    MaterialButtonWidget(
                      onPressed: () async {
                        await eventC.createEvent(
                          image: eventC.image.value,
                          date: eventC.dateC.value.text,
                          location: eventC.locationC.value.text,
                          title: eventC.titleC.value.text,
                          city: eventC.cityC.value.text,
                          description: eventC.descriptionC.value.text,
                          fee: eventC.priceC.value.text,
                        );
                        SendMethod.eventNotification(eventC.titleC.value.text,
                            'Check Out This New Event');
                      },
                      height: 50,
                      width: 170,
                      text: Text(
                        'Create',
                        style: AppTextStyle.regularWhite16,
                      ),
                      color: AppColors.black,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
