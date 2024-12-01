import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/views/screens/event_detail_screen.dart';

import '../models/event.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;

  var isRegistered = false.obs; // Quan sát trạng thái đăng ký
  var showConfirmationDialog = false.obs; // Quan sát hộp thoại xác nhận
  var showSuccessDialog = false.obs; // Quan sát hộp thoại thành công
  var currentDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  void loadEvents() {
    // Load mock data
    events.value = [
      for (int i = 1; i <= 10; i++)
        Event(
          id: i.toString(),
          date: DateTime(2024, 12, i + 10, 14, i * 5 % 60),
          title: "International Band Music Concert" + i.toString(),
          location: "$i Guild Street London, UK ",
          attendees: [
            AppImage.avt1,
            AppImage.avt2,
            AppImage.avt3,
            AppImage.avt1,
            AppImage.avt2,
            AppImage.avt3,
            AppImage.avt1,
            AppImage.avt2,
            AppImage.avt3,
            AppImage.avt1,
            AppImage.avt2,
            AppImage.avt3,
          ],
          image: AppImage.imgEventDefault,
        ),
    ];
  }

  void navigateToEventDetail(String eventId) {
    Get.to(() => EventDetailScreen(eventId: eventId));
  }

  void goBackScreen() {
    Get.back(); // Quay lại màn hình trước
  }

  Event getEventById(String id) {
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      throw Exception("Event not found with id: $id");
    }
  }

  // Hàm để hiển thị hộp thoại xác nhận
  void showDialogConfirmation() {
    showConfirmationDialog.value = true;
  }

  // Hàm để xác nhận đăng ký
  void confirmRegistration() {
    showConfirmationDialog.value = false;
    showSuccessDialog.value = true;
    isRegistered.value = true;
  }

  // Hàm để hủy đăng ký
  void cancelRegistration() {
    showConfirmationDialog.value = false;
  }

  // Thêm hàm chuyển tháng
  void changeMonth(int step) {
    final newDate = DateTime(
      currentDate.value.year,
      currentDate.value.month + step,
    );
    currentDate.value = newDate;
  }

  // Thêm hàm chuyển năm
  void changeYear(int year) {
    final newDate = DateTime(
      year,
      currentDate.value.month,
    );
    currentDate.value = newDate;
  }

  // Thêm hàm kiểm tra sự kiện theo ngày
  Event? getEventByDate(DateTime date) {
    try {
      return events.firstWhere((event) => event.date == date);
    } catch (e) {
      return null; // Nếu không có sự kiện
    }
  }

  // Lấy danh sách ngày và sự kiện trong tháng
  List<Map<String, dynamic>> getMonthDays() {
    int daysInMonth = DateUtils.getDaysInMonth(
      currentDate.value.year,
      currentDate.value.month,
    );

    List<Map<String, dynamic>> days = [];
    int firstWeekday =
        DateTime(currentDate.value.year, currentDate.value.month, 1).weekday;

    // Thêm các ô trống đầu tháng
    for (int i = 0; i < (firstWeekday - 1); i++) {
      days.add({'date': null, 'event': null});
    }

    // Thêm các ngày trong tháng
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date =
          DateTime(currentDate.value.year, currentDate.value.month, i);
      Event? event = events.firstWhereOrNull((e) => e.date == date);
      days.add({'date': date, 'event': event});
    }

    return days;
  }

  List<Map<String, dynamic>> getMonthDaysWithPreviousNext() {
    final DateTime current = currentDate.value;
    int daysInMonth = DateUtils.getDaysInMonth(current.year, current.month);
    DateTime firstDayOfMonth = DateTime(current.year, current.month, 1);

    // Tính ngày cuối của tháng trước
    DateTime lastDayOfPreviousMonth = DateTime(current.year, current.month, 0);

    // Tính các ô trống đầu tháng
    int leadingEmptyCells = (firstDayOfMonth.weekday - 1) % 7;

    List<Map<String, dynamic>> days = [];

    // Thêm ngày của tháng trước
    for (int i = leadingEmptyCells; i > 0; i--) {
      days.add({
        'date': DateTime(lastDayOfPreviousMonth.year,
            lastDayOfPreviousMonth.month, lastDayOfPreviousMonth.day - i + 1),
        'event': null,
        'isCurrentMonth': false
      });
    }

    // Thêm ngày của tháng hiện tại
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(current.year, current.month, i);

      // So sánh chỉ phần ngày của `date` với `event.date`
      Event? event = events.firstWhereOrNull(
        (e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day,
      );

      days.add({'date': date, 'event': event, 'isCurrentMonth': true});
    }

    return days;
  }
}
