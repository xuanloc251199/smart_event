import 'package:get/get.dart';
import 'package:smart_event/models/category.dart';
import '../repositories/category_repository.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  final CategoryRepository repository = Get.find<CategoryRepository>();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final fetchedCategories = await repository.getCategories();
      categories.value = fetchedCategories;
    } catch (e) {
      print('Category Error: Failed to load categories: $e');
    }
  }

  void navigateToEventDetail(String eventId) {
    // Điều hướng đến màn hình chi tiết sự kiện
    // Get.to(() => EventDetailScreen(eventId: eventId));
  }

  void goBackScreen() {
    Get.back(); // Quay lại màn hình trước
  }

  Category getCategoryById(int id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      throw Exception("Category not found with id: $id");
    }
  }
}
