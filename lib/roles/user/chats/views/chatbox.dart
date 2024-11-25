import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/user/chats/controller/chat_controller.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBox extends StatelessWidget {
  ChatBox({super.key});
  static String userID = FirebaseAuth.instance.currentUser!.uid;

  final ChatController chatC = Get.put(ChatController());

  usersStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('users_array', arrayContains: userID)
        .where('last_msg', isNotEqualTo: '')
        .orderBy('last_msg')
        .orderBy('createdAT', descending: true)
        .snapshots();
  }

  getNumber() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('costomer support')
        .doc('nKreGxDX8Voah8N7aVUU')
        .get();
    return data['customer_support'];
  }

  static const String url = 'whatsapp://send?phone=+923019562569';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String number = await getNumber();
          if (await canLaunchUrl(Uri.parse(number))) {
            // Launch the URL.
            await launchUrl(Uri.parse(number));
          } else {
            // Show an error message.
            snackbar('Error', 'No internet connection');
          }
          launchUrl(Uri.parse(url));
        },
        child: const Icon(
          Icons.message,
          color: AppColors.secondary,
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream(),
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
          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'You have no messages',
              style: AppTextStyle.boldBlack16,
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            itemBuilder: (context, index) {
              var docs = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () async {
                  await chatC.getChatID(
                      docs['user_Id'] == userID
                          ? docs['friend_Id']
                          : docs['user_Id'],
                      docs['user_Id'] == userID
                          ? "${docs['friend_name']}".capitalize!
                          : "${docs['user_name']}".capitalize!);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        onBackgroundImageError: (exception, stackTrace) {
                          const Icon(
                            Iconsax.user,
                            color: AppColors.secondary,
                          );
                        },
                        backgroundImage: NetworkImage(docs['user_Id'] == userID
                            ? docs['friend_image']
                            : docs['user_image']),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            docs['user_Id'] == userID
                                ? "${docs['friend_name']}".capitalize!
                                : "${docs['user_name']}".capitalize!,
                            style: AppTextStyle.mediumBlack16,
                          ),
                          Text(
                            docs['user_Id'] == userID
                                ? "${docs['friend_department']}".capitalize!
                                : "${docs['user_department']}".capitalize!,
                            style: AppTextStyle.regularBlack12
                                .copyWith(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}