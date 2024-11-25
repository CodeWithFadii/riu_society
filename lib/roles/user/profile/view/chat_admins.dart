import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/user/chats/controller/chat_controller.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/list_tile_widget.dart';

class ChatAdmins extends StatelessWidget {
  ChatAdmins({super.key});

  final ChatController chatC = Get.put(ChatController());
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  final Stream<QuerySnapshot> subAdmin = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'sub-admin')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Sub Admins',
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: subAdmin,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(
                      child: SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'Please check your internet connection\nand try again!',
                          style: AppTextStyle.regularBlack14,
                        ),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No Sub-Admin Found',
                          style: AppTextStyle.regularBlack14,
                        ),
                      ),
                    );
                  }
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                  itemBuilder: ((context, index) {
                    final docs = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () async {
                        await chatC.getArguments(
                            docs['image'], docs['department']);
                        await chatC.getChatID(
                            docs['id'], '${docs['role']}'.capitalize!);
                      },
                      child: ListTileWidget(
                        name: docs['role'].toString().capitalize,
                        department: docs['department'],
                        image: docs['image'],
                        trailing: const Icon(Iconsax.message),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
