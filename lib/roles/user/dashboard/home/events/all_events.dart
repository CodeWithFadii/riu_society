import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/event_widget.dart';

class AllEvents extends StatelessWidget {
  AllEvents({super.key});
 final Stream<QuerySnapshot<Map<String, dynamic>>> eventStream = FirebaseFirestore
      .instance
      .collection('events')
      .orderBy('time_stamp', descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'All Events',
          style: AppTextStyle.mediumBlack18.copyWith(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: eventStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Please check your internet connection\nand try again!',
                        style: AppTextStyle.regularBlack14,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var docs = snapshot.data!.docs[index];
                      return EventWidget(
                        boxShadow: [
                          BoxShadow(color: AppColors.grey, blurRadius: 10)
                        ],
                        margin: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                        doc: docs,
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
