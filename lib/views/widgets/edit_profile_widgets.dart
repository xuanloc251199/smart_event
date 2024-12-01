// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smart_event/controllers/user_controller.dart';
// import 'package:smart_event/resources/colors.dart';
// import 'package:smart_event/views/widgets/custom_dropdown.dart';
// import 'package:smart_event/views/widgets/custom_text_field_widget.dart';

// class ProfileHeader extends StatelessWidget {
//   final VoidCallback onScanPressed;
//   final VoidCallback onBackPressed;

//   const ProfileHeader({
//     Key? key,
//     required this.onScanPressed,
//     required this.onBackPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: onBackPressed,
//         ),
//         Spacer(),
//         Text("Edit Profile", style: TextStyle(fontSize: 20)),
//         Spacer(),
//         IconButton(
//           icon: Icon(Icons.qr_code_scanner),
//           onPressed: onScanPressed,
//         ),
//       ],
//     );
//   }
// }

// class AvatarSection extends StatelessWidget {
//   final String avatarUrl;
//   final VoidCallback onImageChange;
//   final VoidCallback onCameraCapture;

//   const AvatarSection({
//     Key? key,
//     required this.avatarUrl,
//     required this.onImageChange,
//     required this.onCameraCapture,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         children: [
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: avatarUrl.isNotEmpty
//                 ? NetworkImage(avatarUrl)
//                 : AssetImage('assets/images/default_avatar.png') as ImageProvider,
//           ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: IconButton(
//               icon: Icon(Icons.camera_alt, color: AppColors.primaryColor),
//               onPressed: () {
//                 Get.bottomSheet(
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ListTile(
//                           leading: Icon(Icons.photo_library),
//                           title: Text("Choose from Gallery"),
//                           onTap: onImageChange,
//                         ),
//                         ListTile(
//                           leading: Icon(Icons.camera_alt),
//                           title: Text("Take a Picture"),
//                           onTap: onCameraCapture,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class UserDetailsForm extends StatelessWidget {
//   final UserController userController;

//   const UserDetailsForm({Key? key, required this.userController})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomTextFieldWidget(
//           label: "Full Name",
//           controller: userController.fullNameController,
//         ),
//         SizedBox(height: 16),
//         CustomDropdown(
//           label: "Unit",
//           items: userController.units.map((unit) {
//             return {'id': unit.id, 'name': unit.abbreviation};
//           }).toList(),
//           value: userController.selectedUnit.value?.id,
//           onChanged: (value) {
//             userController.selectUnit(value);
//           },
//         ),
//         SizedBox(height: 16),
//         CustomDropdown(
//           label: "Faculty",
//           items: userController.faculties.map((faculty) {
//             return {'id': faculty.id, 'name': faculty.name};
//           }).toList(),
//           value: userController.selectedFaculty.value?.id,
//           onChanged: (value) {
//             userController.selectFaculty(value);
//           },
//         ),
//         SizedBox(height: 16),
//         CustomDropdown(
//           label: "Class",
//           items: userController.classes.map((classItem) {
//             return {'id': classItem.id, 'name': classItem.name};
//           }).toList(),
//           value: userController.selectedClass.value?.id,
//           onChanged: (value) {
//             userController.selectClass(value);
//           },
//         ),
//       ],
//     );
//   }
// }
