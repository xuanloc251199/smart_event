import 'package:get/get.dart';

import '../views/screens/event/calender_detail_screen.dart';

class CalendarController {
  void navigateToEventDetail(String eventId) {
    Get.to(() => CalenderDetailScreen(eventId: eventId));
  }
}
