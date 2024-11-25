import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riu_society/roles/user/chats/views/chatbox.dart';
import 'package:riu_society/roles/user/forum/views/forum.dart';
import 'package:riu_society/roles/user/dashboard/home/home.dart';
import 'package:riu_society/roles/user/profile/view/profile.dart';
import 'package:riu_society/utils/app_colors.dart';
import 'package:riu_society/utils/functions.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime? lastPressedAt;
  int index = 0;
  List pages = [
    Home(),
    ChatBox(),
    Forum(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressedAt == null ||
            now.difference(lastPressedAt!) > const Duration(seconds: 4)) {
          // Show a snackbar indicating that the user should tap again to exit
          rawSackbar('Tap again to exit');
          lastPressedAt = now;
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: pages[index],
        bottomNavigationBar: Container(
          width: width,
          height: 70,
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MenuItem(
                icon: Iconsax.home,
                isActive: index == 0 ? true : false,
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
              ),
              MenuItem(
                icon: Iconsax.message,
                isActive: index == 1 ? true : false,
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
              ),
              MenuItem(
                icon: Iconsax.note_14,
                isActive: index == 2 ? true : false,
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
              ),
              MenuItem(
                icon: Iconsax.user,
                isActive: index == 3 ? true : false,
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.isActive,
    this.onTap,
    required this.icon,
  }) : super(key: key);
  final bool isActive;
  final Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 4,
            width: 18,
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondary : AppColors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.secondary.withOpacity(0.2)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.secondary : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
