import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/profile_controller.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/styles/_text_header_style.dart';
import 'package:smart_event/views/layouts/custom_header.dart';
import 'package:smart_event/views/screens/face_scan_screen.dart';
import 'package:smart_event/views/screens/face_verify_screen.dart';
import 'package:smart_event/views/screens/profile/qr_scan_screen.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/views/widgets/custom_button_action_icon.dart';
import 'package:smart_event/views/widgets/custom_dropdown.dart';
import 'package:smart_event/views/widgets/custom_text_field_widget.dart';
import 'package:smart_event/views/widgets/icon_image_widget.dart';

class EditProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final ProfileController controller = Get.find<ProfileController>();

  // final ProfileController controller = Get.put(ProfileController());

  final RxMap<String, String> scannedData = RxMap<String, String>();

  // Các TextEditingController cho thông tin người dùng
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController identityCardController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController permanentAddressController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController sexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.fetchUnits();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Obx(() {
            if (userController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = userController.userData;

            print(user);
            updateUserBaseControllers(user);
            print('Email: ${user['email']}');

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpace.spaceSmall,
                      vertical: AppSpace.paddingMain,
                    ),
                    child: CustomHeader(
                      isPreFixIcon: true,
                      prefixIconImage: AppIcons.ic_back,
                      prefixOnTap: Get.back,
                      isSuFixIcon: true,
                      sufixIconImage: AppIcons.ic_scan,
                      sufixOnTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QrScanScreen()),
                        );

                        if (result != null) {
                          scannedData.value = result; // Lưu dữ liệu quét được
                          updateUserBaseControllers(userController.userData);
                        }
                      },
                      headerTitle: AppString.labelProfile,
                      textStyle: AppTextStyle.textTitle1Style,
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
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
                                  : (userController.userData['avatar'] !=
                                              null &&
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap:
                                _showImageSourceOptions, // Sử dụng hàm bên dưới
                            child: Container(
                              padding: EdgeInsets.all(6.px),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(50.px),
                              ),
                              child: IconImageWidget(
                                iconImagePath: AppIcons.ic_camera,
                                width: 16.px,
                                height: 16.px,
                                iconColor: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpace.spaceMain),
                  Center(
                    child: CustomButtonActionIcon(
                      text: AppString.scanFace.toUpperCase(),
                      iconImage: AppIcons.ic_face_scan,
                      isPrimary: false,
                      onPreesed: () async {
                        final result = await Get.to(() => FaceScanScreen());
                        if (result != null) {
                          Get.snackbar('Success', result);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: AppSpace.spaceMain),
                  // Information User
                  CustomTextFieldWidget(
                    isReadOnly: false,
                    isLabel: true,
                    label: AppString.fullName,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: fullNameController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isLabel: true,
                    label: AppString.email,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: emailController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isLabel: true,
                    label: AppString.phone,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: phoneController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isReadOnly: true,
                    isLabel: true,
                    label: AppString.sex,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: sexController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isLabel: true,
                    label: AppString.studentId,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: studentIdController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isReadOnly: true,
                    isLabel: true,
                    label: AppString.identityCard,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: identityCardController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppSpace.spaceSmall, bottom: AppSpace.spaceSmall),
                    child: Text(
                      AppString.university,
                      style: AppTextStyle.textTitle3Style,
                    ),
                  ),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return CustomDropdown(
                      value: controller.selectedUnit.value,
                      hint: AppString.hintUnit,
                      items: [
                        if (controller.units.isEmpty)
                          DropdownMenuItem<int>(
                            value: null,
                            child:
                                Text('N/A'), // Hiển thị N/A nếu danh sách trống
                          ),
                        ...controller.units.map<DropdownMenuItem<int>>((unit) {
                          return DropdownMenuItem<int>(
                            value: unit['id'] as int,
                            child: Text(unit['abbreviation'] ?? 'N/A'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) async {
                        controller.selectedUnit.value = value;
                        if (value != null) {
                          await controller.fetchFaculties(value);
                          controller.selectedFaculty.value =
                              null; // Reset Faculty
                          controller.selectedClass.value = null; // Reset Class
                        }
                      },
                    );
                  }),
                  SizedBox(height: AppSpace.spaceMedium),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppSpace.spaceSmall, bottom: AppSpace.spaceSmall),
                    child: Text(
                      AppString.faculty,
                      style: AppTextStyle.textTitle3Style,
                    ),
                  ),
                  // Dropdown for Faculty
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return CustomDropdown(
                      value: controller.selectedFaculty.value,
                      hint: AppString.hintFaculty,
                      items: [
                        if (controller.faculties.isEmpty)
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text('N/A'),
                          ),
                        ...controller.faculties
                            .map<DropdownMenuItem<int>>((faculty) {
                          return DropdownMenuItem<int>(
                            value: faculty['id'] as int,
                            child: Text(faculty['name'] ?? 'N/A'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) async {
                        controller.selectedFaculty.value = value;
                        if (value != null) {
                          await controller.fetchClasses(value);
                          controller.selectedClass.value = null; // Reset Class
                        }
                      },
                    );
                  }),
                  SizedBox(height: AppSpace.spaceMedium),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppSpace.spaceSmall, bottom: AppSpace.spaceSmall),
                    child: Text(
                      AppString.className,
                      style: AppTextStyle.textTitle3Style,
                    ),
                  ),
                  // Dropdown for Class
                  CustomDropdown(
                    value: controller.selectedClass.value,
                    hint: AppString.hintClass,
                    items: [
                      if (controller.classes.isEmpty)
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text('N/A'),
                        ),
                      ...controller.classes
                          .map<DropdownMenuItem<int>>((classItem) {
                        return DropdownMenuItem<int>(
                          value: classItem['id'] as int,
                          child: Text(classItem['class_name'] ?? 'N/A'),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      controller.selectedClass.value = value;
                    },
                  ),

                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isReadOnly: true,
                    isLabel: true,
                    label: AppString.address,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: addressController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isReadOnly: true,
                    isLabel: true,
                    label: AppString.dob,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: dobController,
                  ),
                  SizedBox(height: AppSpace.spaceMedium),
                  // Nút lưu thông tin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        isFill: false,
                        text: AppString.cancel,
                        textStyle: AppTextStyle.textButtonHighlightStyle,
                        onPressed: () => Get.back(),
                        width:
                            50.w - AppSpace.spaceMedium - AppSpace.spaceSmall,
                      ),
                      SizedBox(
                        width: AppSpace.spaceSmall,
                      ),
                      CustomButton(
                        width:
                            50.w - AppSpace.spaceMedium - AppSpace.spaceSmall,
                        text: AppString.save,
                        onPressed: () {
                          userController.updateUserDetails(
                            fullName: fullNameController.text,
                            sex: sexController.text,
                            phone: phoneController.text,
                            dob: dobController.text,
                            address: addressController.text,
                            permanentAddress: permanentAddressController.text,
                            identityCard: identityCardController.text,
                            studentId: studentIdController.text,
                            selectedUnitId: controller.selectedUnit.value,
                            selectedFacultyId: controller.selectedFaculty.value,
                            selectedClassId: controller.selectedClass.value,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void updateUserBaseControllers(RxMap<String, dynamic> user) {
    fullNameController.text =
        scannedData['Họ và tên'] ?? user['full_name'] ?? '';
    identityCardController.text =
        scannedData['CCCD'] ?? user['identity_card'] ?? '';
    addressController.text =
        scannedData['Địa chỉ thường trú'] ?? user['address'] ?? '';
    dobController.text =
        scannedData['Ngày sinh'] ?? user['date_of_birth'] ?? '';
    sexController.text = scannedData['Giới tính'] ?? user['sex'] ?? '';

    // Các trường khác giữ nguyên logic
    emailController.text = user['email'] ?? '';
    phoneController.text = user['phone'] ?? '';
    userNameController.text = user['username'] ?? '';
    studentIdController.text = user['student_id'] ?? '';
    universityController.text = user['unit_id'] ?? '';
    facultyController.text = user['faculty_id'] ?? '';
    classNameController.text = user['class_id'] ?? '';
    permanentAddressController.text = user['permanent_address'] ?? '';
  }

  void _showImageSourceOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.px),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.px)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Chọn ảnh từ thư viện'),
              onTap: () {
                Get.back(); // Đóng bottomSheet
                userController.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Chụp ảnh'),
              onTap: () {
                Get.back(); // Đóng bottomSheet
                userController.pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}
