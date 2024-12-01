import 'package:get/get.dart';

class SidebarController extends GetxController {
  var isSidebarOpen = false.obs;

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }
}
