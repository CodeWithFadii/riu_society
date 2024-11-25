import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/common/notification/send_method.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/functions.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../../utils/widgets/list_tile_widget.dart';

class CommunityDetails extends StatefulWidget {
  const CommunityDetails(
      {super.key,
      required this.id,
      required this.name,
      required this.memberCount});
  final String id;
  final String name;
  final int memberCount;

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  var controller = TextEditingController();
  List optionsList = <String>['Kickout User', 'Make Sub Admin'];
  late Stream<QuerySnapshot> members = FirebaseFirestore.instance
      .collection('societies')
      .doc(widget.id)
      .collection('members')
      .snapshots();

  Future<void> onDelete(QueryDocumentSnapshot<Object?> doc) async {
    int count = widget.memberCount - 1;
    CollectionReference society =
        FirebaseFirestore.instance.collection('societies');
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    await society.doc(widget.id).update({'members_count': count});
    await society.doc(widget.id).collection('members').doc(doc.id).delete();
    await user.doc(doc.id).update(
      {
        'community_id': 'N/A',
        'community_name': 'N/A',
      },
    ).then((value) => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width * 1;
    final sizeh = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.name,
          style: AppTextStyle.regularWhite18,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: sizew * 0.040),
            height: sizeh * 0.18,
            color: AppColors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleTextField(
                  borderRadius: 10,
                  width: double.infinity,
                  controller: controller,
                  hint: 'Search by name...',
                  hintstyle: AppTextStyle.regularBlack14
                      .copyWith(color: AppColors.grey),
                  trailing: Iconsax.search_normal,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        members = FirebaseFirestore.instance
                            .collection('societies')
                            .doc(widget.id)
                            .collection('members')
                            .where('name',
                                isGreaterThanOrEqualTo: value.toLowerCase())
                            .where('name',
                                isLessThan: '${value.toLowerCase()}z')
                            .snapshots();
                      });
                    } else {
                      setState(() {
                        members = FirebaseFirestore.instance
                            .collection('societies')
                            .doc(widget.id)
                            .collection('members')
                            .snapshots();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: members,
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
                          'No Member Yet',
                          style: AppTextStyle.regularBlack14,
                        ),
                      ),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      itemCount: docs.length,
                      itemBuilder: ((context, index) {
                        return ListTileWidget(
                          name: docs[index]['name'].toString().capitalize,
                          department: docs[index]['student']
                              ? '${docs[index]['department']}👨‍🎓'
                              : '${docs[index]['department']}👨‍🏫',
                          image: docs[index]['image'],
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_horiz_outlined),
                            itemBuilder: (BuildContext context) {
                              return optionsList.map(
                                (e) {
                                  return PopupMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: AppTextStyle.mediumBlack16,
                                    ),
                                  );
                                },
                              ).toList();
                            },
                            onSelected: (value) {
                              if (value == optionsList[0]) {
                                confirmDefaultDialog('Kickout User',
                                    'Are you sure? If you remove this user, Then user will have to join another society.',
                                    confirm: () async {
                                  await onDelete(docs[index]);
                                  DocumentSnapshot snap =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(docs[index]['id'])
                                          .get();
                                  final token = snap['fcm_token'];
                                  SendMethod.sendNotification(
                                      'Admin removed ${docs[index]['name']} from ${widget.name} society',
                                      'If you were the member of this society then be sure to join a new society. Profile>Editprofile>ChooseSociety>Update',
                                      token);
                                  Get.back();
                                });
                              } else {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(docs[index].id)
                                    .update({
                                  'role': 'sub-admin'
                                }).then((value) => rawSackbar(
                                        'You made ${docs[index]['name']} Sub-admin'
                                            .capitalize!));
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
