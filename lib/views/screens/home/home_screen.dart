import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/category_controller.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/resources/sizes.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/views/layouts/home/category_list.dart';
import 'package:smart_event/views/widgets/section_header.dart';
import 'package:smart_event/views/layouts/home/custom_side_bar.dart';
import 'package:smart_event/views/layouts/home/event_section.dart';
import 'package:smart_event/views/layouts/home/recoment_event_section.dart';
import '../../../controllers/event_controller.dart';
import '../../../controllers/side_bar_controller.dart';
import '../../../resources/colors.dart';
import '../../layouts/home/header.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/icon_image_widget.dart';

class HomeScreen extends StatelessWidget {
  final SidebarController sidebarController = Get.find<SidebarController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final EventController eventController = Get.find<EventController>();
  final UserController userController = Get.find<UserController>();
  final UserRepository userRepository = Get.find<UserRepository>();

  @override
  Widget build(BuildContext context) {
    print('Token: ${userRepository.getToken()}');
    return Scaffold(
      body: Stack(
        children: [
          // Sidebar
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              left: sidebarController.isSidebarOpen.value ? 0.0 : -75.w,
              top: 0.0,
              bottom: 0.0,
              child: CustomSideBar(),
            ),
          ),

          // Main content
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              left: sidebarController.isSidebarOpen.value ? 70.w : 0.0,
              top: 0.0,
              right: sidebarController.isSidebarOpen.value ? -70.w : 0.0,
              bottom: 0.0,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (sidebarController.isSidebarOpen.value) {
                    sidebarController.toggleSidebar();
                  }
                },
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // Fixed Header and Search
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpace.spaceMedium,
                                vertical: AppSpace.paddingMain,
                              ),
                              child: Header(
                                sidebarController: sidebarController,
                              ),
                            ),
                            // Search
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpace.paddingMain,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFieldWidget(
                                      hintText: AppString.searchHint,
                                      isFill: true,
                                      prefixImage: AppIcons.ic_search,
                                      prefixColor: AppColors.hidenColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {},
                                    child: IconImageWidget(
                                      iconImagePath: AppIcons.ic_filter,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSpace.spaceMain),
                          ],
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildListDelegate([
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSpace.paddingMain),
                                child: SectionHeader(title: AppString.category),
                              ),
                              SizedBox(
                                height: AppSpace.spaceSmall,
                              ),
                              Obx(
                                () {
                                  if (categoryController.categories.isEmpty) {
                                    return Center(
                                      child: Text(
                                        AppString.erCategory,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  }
                                  return CategoryList(
                                      controller: categoryController);
                                },
                              ),
                              SizedBox(
                                height: AppSpace.spaceMain,
                              ),
                            ],
                          ),
                          RecomentEventSection(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSpace.paddingMain),
                            child: Container(
                              height: 127.px,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.brMain,
                                ),
                                child: Image.asset(
                                  AppImage.imgTest1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppSpace.spaceMain,
                          ),
                          EventSection(eventController: eventController),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
