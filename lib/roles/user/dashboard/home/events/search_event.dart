import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/app_textstyle.dart';
import 'package:riu_society/utils/widgets/event_widget.dart';
import 'package:riu_society/utils/widgets/simple_textfield.dart';

class SearchEvent extends StatefulWidget {
  const SearchEvent({super.key});

  @override
  State<SearchEvent> createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {
  final TextEditingController searchC = TextEditingController();
  String searchedForum = '';
  @override
  void initState() {
    super.initState();
    searchC.addListener(() {
      setState(() {
        searchedForum = searchC.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Search Event',
          style: AppTextStyle.mediumBlack18.copyWith(color: AppColors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16, left: 14, right: 14),
            child: SimpleTextField(
              autoFocus: true,
              width: double.infinity,
              controller: searchC,
              hint: 'Find events with community name...',
              trailing: Iconsax.search_normal,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: searchedPosts(),
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
                    'No Posts Available',
                    style: AppTextStyle.mediumBlack16,
                  ));
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return EventWidget(
                      boxShadow: [
                        BoxShadow(color: AppColors.grey, blurRadius: 10)
                      ],
                      margin: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      doc: snapshot.data!.docs[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  searchedPosts() {
    print(searchedForum.capitalize);
    return searchedForum.isEmpty
        ? FirebaseFirestore.instance.collection('events').snapshots()
        : FirebaseFirestore.instance
            .collection('events')
            .where('community_name',
                isGreaterThanOrEqualTo: searchedForum.capitalize)
            .snapshots();
  }
}
