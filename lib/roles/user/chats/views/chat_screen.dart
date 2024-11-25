import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riu_society/roles/common/notification/send_method.dart';
import 'package:riu_society/roles/user/chats/controller/chat_controller.dart';
import 'package:riu_society/roles/user/chats/views/chat_bubble.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/bubble_const.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(
      {super.key,
      required this.friendName,
      required this.friendId,
      required this.userName});
  final String friendName;
  final String friendId;
  final RxString userName;
  final ChatController chatC = Get.find<ChatController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(friendName,
              style: AppTextStyle.boldBlack18.copyWith(color: AppColors.white)),
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Obx(
            () {
              return Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: chatC.getMessages(chatC.chatID.value),
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
                        }

                        return ListView.builder(
                          itemBuilder: (context, index) {
                            var docs = snapshot.data!.docs[index];
                            return chatBubbleWidget(docs);
                          },
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                        );
                      },
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    color: AppColors.black,
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                                controller: chatC.messageC,
                                maxLines: 1,
                                decoration: ktextfield)),
                        GestureDetector(
                          onTap: () async {
                            print(friendId);
                            await chatC.sendMessage(chatC.messageC.text);
                            DocumentSnapshot doc = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(friendId)
                                .get();
                            final id = doc['fcm_token'];
                            SendMethod.sendNotification(
                                userName.value.capitalize!,
                                chatC.messageC.text,
                                id);
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.white,
                            child: Icon(
                              Icons.send,
                              color: AppColors.grey,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
