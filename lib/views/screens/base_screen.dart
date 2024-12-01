import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/controllers/bottom_nav_controller.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/services/api_service.dart';
import 'package:smart_event/views/screens/add_screen.dart';
import 'package:smart_event/views/screens/event_screen.dart';
import 'package:smart_event/views/screens/home_screen.dart';
import 'package:smart_event/views/screens/map_screen.dart';
import 'package:smart_event/views/screens/search_screen.dart';
import 'package:smart_event/views/screens/profile_screen.dart';

import '../layouts/custom_bottom_nav_bar.dart';

class BaseScreen extends StatelessWidget {
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  final UserController userController =
      Get.put(UserController(UserRepository(ApiService())));

  final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    EventScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return screens[bottomNavController.selectedIndex.value];
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
