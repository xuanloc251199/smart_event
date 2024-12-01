import 'package:get/get.dart';
import 'package:smart_event/models/category.dart';
import 'package:smart_event/resources/icons.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    // Load mock data
    categories.value = [
      for (int i = 1; i <= 10; i++)
        Category(
            id: i.toString(),
            category: "Category $i",
            thumbnail: AppIcons.ic_ws)
    ];
  }

  void navigateToEventDetail(String eventId) {
    // Get.to(() => EventDetailScreen(eventId: eventId));
  }

  void goBackScreen() {
    Get.back(); // Quay lại màn hình trước
  }

  Category getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      throw Exception("Category not found with id: $id");
    }
  }
}
