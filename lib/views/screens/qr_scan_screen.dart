import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smart_event/controllers/qr_scan_controller.dart';

class QrScanScreen extends StatelessWidget {
  final QrScanController qrScanController = Get.put(QrScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // MobileScanner cho camera feed
          MobileScanner(
            onDetect: (BarcodeCapture barcodeCapture) {
              final Barcode? barcode = barcodeCapture.barcodes.first;
              if (barcode != null && barcode.rawValue != null) {
                qrScanController
                    .processQrData(barcode.rawValue!); // Xử lý dữ liệu
                Get.back(
                    result: qrScanController.scannedData); // Trả kết quả về
              }
            },
          ),

          // Overlay hiệu ứng khung quét QR code
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Hướng dẫn quét QR
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Scan your QR Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Align the QR code inside the box",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Nút "Cancel"
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Quay lại màn hình trước
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
