import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/controllers/sign_out_controller.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/models/event.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/resources/sizes.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/services/api_service.dart';
import 'package:smart_event/views/layouts/custom_header.dart';
import 'package:smart_event/views/screens/edit_profile_screen.dart';

import '../../styles/_button_style.dart';
import '../../styles/_text_header_style.dart';

class ProfileScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());
  final SignOutController signOutController =
      Get.put(SignOutController(UserRepository(ApiService())));

  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (userController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final user = userController.userData;
          print('User Data in ProfileScreen: $user');
          print('Full name: ${user['full_name']}');
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpace.spaceMedium,
                  vertical: AppSpace.paddingMain,
                ),
                child: CustomHeader(
                  isPreFixIcon: false,
                  isSuFixIcon: true,
                  sufixIconImage: AppIcons.ic_sign_out,
                  sufixOnTap: () {
                    signOutController.signOut();
                  },
                  headerTitle: AppString.labelProfile,
                  textStyle: AppTextStyle.textTitle1Style,
                ),
              ),
              // Profile Avatar và thông tin
              Column(
                children: [
                  Center(
                    child: Obx(() {
                      return Container(
                        width: 100.px,
                        height: 100.px,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.px),
                          border: Border.all(
                            width: 2,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.px),
                          child: userController.selectedAvatar.value != null
                              ? Image.file(
                                  userController.selectedAvatar.value!,
                                  width: 100.px,
                                  height: 100.px,
                                  fit: BoxFit.cover,
                                )
                              : (userController.userData['avatar'] != null &&
                                      userController
                                          .userData['avatar'].isNotEmpty
                                  ? Image.network(
                                      userController.userData[
                                          'avatar'], // Hiển thị avatar từ URL
                                      width: 100.px,
                                      height: 100.px,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      AppImage.imgAvatarDefault,
                                      width: 100.px,
                                      height: 100.px,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  Text(user['full_name'] ?? user['email'],
                      style: AppTextStyle.textTitle1Style),
                  SizedBox(height: AppSpace.spaceMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem("350", "Following"),
                      SizedBox(width: 40),
                      _buildStatItem("346", "Followers"),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildButton(AppString.editProfile, AppIcons.ic_edit, false),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _buildButton(AppString.follow, AppIcons.ic_follow, true),
                  //     SizedBox(width: 10),
                  //     _buildButton(AppString.titleMassage, AppIcons.ic_massage, false),
                  //   ],
                  // ),
                  SizedBox(height: 12),
                ],
              ),
              // TabBar và TabBarView
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: AppColors.primaryColor,
                        labelColor: AppColors.primaryColor,
                        unselectedLabelColor: AppColors.textHintColor,
                        tabs: [
                          Tab(text: "ABOUT"),
                          Tab(text: "EVENT"),
                          Tab(text: "REVIEWS"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildAboutTab(),
                            _buildEventTab(),
                            _buildReviewTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Widget thống kê (Following và Followers)
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.textTitle2Style,
        ),
        Text(label, style: AppTextStyle.textSubTitle2Style),
      ],
    );
  }

  // Nút Follow và Messages
  Widget _buildButton(String text, String iconImage, bool isPrimary) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.to(() => EditProfileScreen());
      },
      icon: Image.asset(iconImage,
          width: AppSizes.iconButtonSize,
          color: isPrimary ? AppColors.whiteColor : AppColors.primaryColor),
      label: Text(
        text,
        style: AppTextStyle.textButtonSmallStyle.copyWith(
          color: isPrimary ? AppColors.whiteColor : AppColors.primaryColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? AppColors.primaryColor : AppColors.whiteColor,
        side: isPrimary
            ? BorderSide.none
            : BorderSide(color: AppColors.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shadowColor: AppColors.buttonShadowColor,
      ),
    );
  }

  // ABOUT Tab
  Widget _buildAboutTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "David is an event enthusiast and social butterfly. "
        "He loves attending musical nights and conferences, "
        "connecting with people, and sharing knowledge.",
        style: AppTextStyle.textSubTitle1Style,
      ),
    );
  }

  // EVENT Tab - Lấy dữ liệu từ EventController
  Widget _buildEventTab() {
    return Obx(() {
      return ListView.builder(
        itemCount: eventController.events.length,
        itemBuilder: (context, index) {
          final Event event = eventController.events[index];
          return _buildEventCard(event);
        },
      );
    });
  }

  // Widget Event Card
  Widget _buildEventCard(Event event) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(AppSpace.spaceSmall),
      decoration: AppButtonStyle.buttonShadowDecor,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              event.image,
              width: 79.px,
              height: 92.px,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: AppSpace.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${event.day} ${event.monthName} ${event.date.year} • ${event.formattedTime}",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                SizedBox(height: AppSpace.spaceSmallW),
                Text(
                  event.title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: AppSpace.spaceSmallW),
                Text(
                  event.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // REVIEWS Tab
  Widget _buildReviewTab() {
    return Center(
      child: Text(
        "No reviews yet.",
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}
