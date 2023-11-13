import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paywise_android/src/features/core/screens/dashboard/seperator.dart';
import 'package:paywise_android/src/features/core/screens/dashboard/user_dashboard_grid_tile.dart';
import 'package:paywise_android/src/features/core/screens/profile/search_user.dart';
import 'package:paywise_android/src/features/payment/screens/transaction_history.dart';
import '../../../../constants/constants.dart';
import '../profile/profile_screen.dart';
import 'carousel_slider_widget.dart';
import 'invite_section.dart';
import 'option_list.dart';

class DashBoard extends StatefulWidget {
  final User? user;
  const DashBoard({super.key, this.user});
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: tPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(tDefaultSize), border: Border.all(color: Colors.blue, width: 1)),
          child: TextFormField(
            controller: searchController,
            onChanged: (value) => Get.to(() => SearchUser(searchController: searchController, user: widget.user)),
            decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(tDefaultSize))),
              hintText: tSearch,
              hintStyle: TextStyle(color: tGreyColor),
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => Get.to(() => const ProfileScreen()),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                  shape: BoxShape.circle,
                  color: tWhiteColor,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.person, color: Colors.green, size: 25),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const CarouselImage(),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            builder: (BuildContext context, ScrollController myScrollController) {
              return ListView.builder(
                controller: myScrollController,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(tDefaultSize),
                            topRight: Radius.circular(tDefaultSize),
                          ),
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            //Scroll Handle
                            Center(
                              child: Container(
                                height: 5,
                                width: 45,
                                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            //Action list
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [OptionList()],
                            ),
                            const SizedBox(height: 20),
                            const Seperator(),
                            const SizedBox(height: 20),
                            //People header
                            const Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: Row(children: [Text('People', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: tDarkColor))]),
                            ),
                            const SizedBox(height: 20),
                            //chat icons
                            UserDashboardGridTile(controller: myScrollController),
                            const SizedBox(height: 20),
                            const Seperator(),
                            //history
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Get.to(() => const TransactionHistory()),
                                child: const Text('Show all transactions', style: TextStyle(color: tDarkColor, fontSize: 16)),
                              ),
                            ),
                            const Seperator(),
                            const InviteSection(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
