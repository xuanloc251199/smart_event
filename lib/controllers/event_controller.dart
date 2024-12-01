import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/repositories/event_repository.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/services/api_service.dart';
import 'package:smart_event/views/screens/event/event_detail_screen.dart';

import '../models/event.dart';

class EventController extends GetxController {
  final EventRepository eventRepository = Get.find<EventRepository>();
  final UserController userController = Get.find<UserController>();

  var events = <Event>[].obs;
  var isLoading = false.obs;
  Timer? _autoRefreshTimer;

  var isRegistered = false.obs; // Quan sát trạng thái đăng ký
  var showConfirmationDialog = false.obs; // Quan sát hộp thoại xác nhận
  var showRegistration = false.obs; // Quan sát hộp thoại người dùng đăng ký
  var showSuccessDialog = false.obs; // Quan sát hộp thoại thành công
  var currentDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    // loadEvents();
    fetchEvents();
    startAutoRefresh();
  }

  @override
  void onClose() {
    _autoRefreshTimer?.cancel(); // Cancel timer on close
    super.onClose();
  }

  Future<void> fetchEvents() async {
    isLoading(true);
    try {
      final fetchedEvents = await eventRepository.fetchEvents();
      events.assignAll(fetchedEvents); // Gán danh sách sự kiện vào `events`
    } catch (e) {
      printError(info: 'Error event: Failed to fetch events: $e');
    } finally {
      isLoading(false);
    }
  }

  void startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(
      Duration(minutes: 30), // Adjust refresh interval as needed
      (timer) => fetchEvents(),
    );
  }

  void refreshEventsImmediately() async {
    try {
      await fetchEvents(); // Gọi hàm fetchEvents để cập nhật danh sách sự kiện
      printInfo(info: 'Events refreshed immediately.');
    } catch (e) {
      printError(info: 'Error refreshing events: $e');
    }
  }

  void navigateToEventDetail(String eventId) {
    Get.to(() => EventDetailScreen(eventId: eventId));
  }

  void goBackScreen() {
    Get.back(); // Quay lại màn hình trước
  }

  Event getEventById(String id) {
    try {
      fetchEventById(id);
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      throw Exception("Event not found with id: $id");
    }
  }

  void fetchEventById(String eventId) async {
    try {
      final fetchedEvent = await eventRepository.fetchEventById(eventId);
      int index = events.indexWhere((event) => event.id == eventId);
      if (index != -1) {
        events[index] = fetchedEvent;
      } else {
        events.add(fetchedEvent);
      }
      events.refresh(); // Làm mới danh sách sự kiện
    } catch (e) {
      print("Error fetching event by ID: $e");
    }
  }

  // Hàm để hiển thị hộp thoại xác nhận
  void showDialogConfirmation() {
    showConfirmationDialog.value = true;
  }

  void showRegistrated() {
    showRegistration.value = true;
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
    showRegistration.value = false;
  }

  // Kiểm tra trạng thái của người dùng trong sự kiện
  String checkUserStatus(Event event) {
    final userId = userController.userData['id']; // Lấy `id` của user hiện tại
    final registration =
        event.registrations.firstWhereOrNull((reg) => reg.userId == userId);

    return registration?.status ?? 'no_register';
  }

  // Kiểm tra trạng thái của nút
  String getButtonStatus(Event event) {
    final userId = userController.userData['id'];
    final now = DateTime.now();

    printInfo(info: 'UserID: $userId');
    printInfo(info: 'Current time: $now');
    printInfo(info: 'Event time: ${event.date}');

    // Tìm bản ghi đăng ký của người dùng hiện tại
    final registration =
        event.registrations.firstWhereOrNull((reg) => reg.userId == userId);
    printInfo(info: 'Status: ${registration?.status}');
    printInfo(info: 'Is Registed: ${registration?.isRegister}');

    // Trường hợp chưa từng đăng ký
    if (registration == null) {
      printInfo(
          info:
              'Registration is null. User has not registered for this event.');

      if (now.isBefore(event.date.subtract(const Duration(days: 1)))) {
        printInfo(info: 'Event has not started. Returning "register".');
        return 'register';
      }

      if (now.isAfter(event.date.subtract(const Duration(minutes: 15))) &&
          now.isBefore(event.date.add(const Duration(minutes: 15)))) {
        printInfo(info: 'Check-in period active. Returning "check_in".');
        return 'check_in';
      }

      if (now.isAfter(event.date.add(const Duration(minutes: 15)))) {
        printInfo(info: 'Event has ended. Returning "disabled".');
        return 'disabled';
      }

      return 'disabled';
    }

    // Trường hợp đã đăng ký
    if (registration.isRegister == true) {
      printInfo(info: 'User has registered.');

      if (registration.status == 'checked_in') {
        return 'checked_in';
      }
      // Khi trạng thái chưa được cập nhật
      else if (registration.status == null) {
        printInfo(info: 'Registration status is null.');

        // Trong thời gian check-in
        if (now.isAfter(event.date.subtract(const Duration(minutes: 15))) &&
            now.isBefore(event.date.add(const Duration(minutes: 15)))) {
          printInfo(info: 'Check-in period active. Returning "check_in".');
          return 'check_in'; // Trong khoảng thời gian check-in
        }

        // Sau thời gian check-in
        if (now.isAfter(event.date.add(const Duration(minutes: 15)))) {
          printInfo(info: 'Check-in period expired. Returning "absent".');
          return 'absent'; // Quá thời gian check-in
        }

        // Trước khi sự kiện bắt đầu
        if (now.isBefore(event.date)) {
          printInfo(info: 'Event has not started. Returning "registered".');
          return 'registered'; // Đăng ký nhưng chưa thể check-in
        }
      }

      // Khi trạng thái đã được cập nhật
      switch (registration.status) {
        case 'checked_in':
          printInfo(
              info: 'User has already checked in. Returning "checked_in".');
          return 'checked_in';
        case 'absent':
          printInfo(
              info: 'User has been marked as absent. Returning "absent".');
          return 'absent';
        default:
          printInfo(info: 'Unknown status. Returning "disabled".');
          return 'disabled';
      }
    }

    printInfo(info: 'No matching condition found. Returning "disabled".');
    return 'disabled';
  }

  void registerEvent(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? prefs.getString('temp_token');

      if (token != null) {
        final response = await eventRepository.register(eventId, token);
        if (response.statusCode == 200) {
          print('Registration successful: ${response.data}');
        }
      } else {
        Get.log('Error: No token found.');
      }
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  void checkInEvent(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? prefs.getString('temp_token');

      if (token != null) {
        final response = await eventRepository.checkIn(eventId, token);
        if (response.statusCode == 200) {
          print('Check-in successful: ${response.data}');
        }
      } else {
        Get.log('Error: No token found.');
      }
    } catch (e) {
      print('Check-in failed: $e');
    }
  }

  //==================================================//
  //
  // Xử lý logic Calender
  //
  //==================================================//

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
