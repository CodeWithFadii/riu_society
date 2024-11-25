import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/user/chats/controller/chat_controller.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/functions.dart';

class SocietyMembers extends StatelessWidget {
  SocietyMembers({super.key, required this.id});
  final ChatController chatC = Get.put(ChatController());
  final String id;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late final Stream<QuerySnapshot> members = FirebaseFirestore.instance
      .collection('societies')
      .doc(id)
      .collection('members')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: const Text('All Members'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: members,
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
                    'No Member Found',
                    style: AppTextStyle.regularBlack14,
                  ),
                );
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 20, left: 14, right: 14),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      if (docs[index]['id'] != userId) {
                        await chatC.getArguments(
                            docs[index]['image'], docs[index]['department']);
                        await chatC.getChatID(docs[index]['id'],
                            '${docs[index]['name']}'.capitalize!);
                      } else {
                        rawSackbar('You cannot chat with yourself!');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.only(right: 14),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                  docs[index]['image'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${docs[index]['name']}'.capitalize!,
                                style: AppTextStyle.mediumBlack16,
                              ),
                              Text(
                                docs[index]['department'],
                                style: AppTextStyle.regularBlack14,
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
