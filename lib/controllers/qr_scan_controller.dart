import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanController extends GetxController {
  RxMap<String, String> scannedData =
      RxMap<String, String>(); // Lưu dữ liệu quét

  late final MobileScannerController scannerController;

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo camera controller
    scannerController = MobileScannerController();

    // Đặt zoom mặc định là 2x
    // Lưu ý giá trị maxZoom có thể thay đổi tuỳ thiết bị (thường 5.0 hoặc cao hơn)
    setZoomLevel(2.0);
  }

  // Hàm setZoomLevel() để điều chỉnh zoom thủ công
  Future<void> setZoomLevel(double zoom) async {
    await scannerController.setZoomScale(zoom);
  }

  // Hàm xử lý chuỗi QR Code
  void processQrData(String qrString) {
    try {
      final data = qrString.split('|');
      if (data.length >= 7) {
        scannedData.clear(); // Đảm bảo không lưu dữ liệu cũ
        scannedData['CCCD'] = data[0];
        scannedData['CMND'] = data[1];
        scannedData['Họ và tên'] = data[2];
        scannedData['Ngày sinh'] = formatDate(data[3]);
        scannedData['Giới tính'] = data[4];
        scannedData['Địa chỉ thường trú'] = data[5];
        scannedData['Ngày đăng ký CCCD'] = formatDate(data[6]);
      } else {
        throw Exception('Invalid QR data format.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to process QR Code: $e');
    }
  }

  // Hàm định dạng ngày từ ddMMyyyy sang dd/MM/yyyy
  String formatDate(String date) {
    if (date.length == 8) {
      return '${date.substring(0, 2)}-${date.substring(2, 4)}-${date.substring(4)}';
    }
    return date;
  }
}
