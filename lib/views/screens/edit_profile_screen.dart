import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/sign_out_controller.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/services/api_service.dart';
import 'package:smart_event/styles/_text_header_style.dart';
import 'package:smart_event/views/layouts/custom_header.dart';
import 'package:smart_event/views/screens/face_scan_screen.dart';
import 'package:smart_event/views/screens/face_verification_screen.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/views/widgets/custom_dropdown.dart';
import 'package:smart_event/views/widgets/custom_text_field_widget.dart';
import 'package:smart_event/views/widgets/icon_image_widget.dart';
import 'qr_scan_screen.dart';

class EditProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        isFill: false,
                        width:
                            50.w - AppSpace.spaceMedium - AppSpace.spaceSmall,
                        text: AppString.btnScanTitle,
                        textStyle: AppTextStyle.textButtonHighlightStyle,
                        onPressed: () async {
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
                      ),
                      SizedBox(
                        width: AppSpace.spaceSmall,
                      ),
                      CustomButton(
                        width:
                            50.w - AppSpace.spaceMedium - AppSpace.spaceSmall,
                        text: AppString.scanFace,
                        onPressed: () async {
                          final result = await Get.to(() => FaceScanScreen());
                          if (result != null) {
                            Get.snackbar('Success', result);
                          }
                        },
                      ),
                    ],
                  ),
                  // CustomButton(
                  //   width: 50.w - AppSpace.spaceMedium - AppSpace.spaceSmall,
                  //   text: AppString.scanFace,
                  //   onPressed: () {
                  //     Get.to(() => FaceVerificationScreen());
                  //   },
                  // ),
                  SizedBox(height: AppSpace.spaceMain),
                  // Information User
                  CustomTextFieldWidget(
                    isReadOnly: true,
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
                  // Faculty Dropdown
                  Obx(() {
                    return CustomDropdown(
                      isLabel: true,
                      label: AppString.faculty,
                      labelStyle: AppTextStyle.textTitle3Style,
                      value: userController.selectedFacultyId.isNotEmpty
                          ? userController.selectedFacultyId.value
                          : null,
                      items: userController.faculties,
                      hint: 'Select Faculty',
                      onChanged: (value) {
                        if (value != null) {
                          userController.selectedFacultyId.value = value;
                          userController.filterClassesByFaculty(value);
                        }
                      },
                    );
                  }),
                  SizedBox(height: AppSpace.spaceMedium),
                  Obx(() {
                    return CustomDropdown(
                      isLabel: true,
                      label: AppString.className,
                      labelStyle: AppTextStyle.textTitle3Style,
                      value: userController.selectedClassId.isNotEmpty
                          ? userController.selectedClassId.value
                          : null,
                      items: userController.filteredClasses,
                      hint: 'Select Class',
                      onChanged: (value) {
                        if (value != null) {
                          userController.selectedClassId.value = value;
                        }
                      },
                    );
                  }),
                  SizedBox(height: AppSpace.spaceMedium),
                  CustomTextFieldWidget(
                    isLabel: true,
                    label: AppString.university,
                    labelStyle: AppTextStyle.textTitle3Style,
                    controller: universityController,
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
                        text: AppString.save,
                        onPressed: () {
                          userController.updateProfileWithAvatar(
                            fullName: fullNameController.text,
                            sex: sexController.text,
                            phone: phoneController.text,
                            dob: dobController.text,
                            address: addressController.text,
                            permanentAddress: permanentAddressController.text,
                            identityCard: identityCardController.text,
                            studentId: studentIdController.text,
                            university: universityController.text,
                            selectedFacultyId:
                                userController.selectedFacultyId.value,
                            selectedClassId:
                                userController.selectedClassId.value,
                          );
                        },
                        width:
                            50.w - AppSpace.spaceMedium - AppSpace.spaceSmall,
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
    classNameController.text = user['class'] ?? '';
    facultyController.text = user['faculty'] ?? '';
    universityController.text = user['university'] ?? '';
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
