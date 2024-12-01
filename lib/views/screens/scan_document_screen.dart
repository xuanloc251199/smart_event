// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class ScanDocumentScreen extends StatefulWidget {
//   @override
//   _ScanDocumentScreenState createState() => _ScanDocumentScreenState();
// }

// class _ScanDocumentScreenState extends State<ScanDocumentScreen> {
//   final ImagePicker _picker = ImagePicker();
//   File? _imageFile;

//   Future<void> pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });

//       // Thực hiện OCR
//       final result = await scanCccd(_imageFile!);
//       Get.back(result: result); // Trả về dữ liệu quét
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Scan Document')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _imageFile != null
//                 ? Image.file(_imageFile!, height: 300)
//                 : Container(
//                     height: 300,
//                     color: Colors.grey[300],
//                     child: Center(child: Text('No Image Selected')),
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: Text('Capture CCCD'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
