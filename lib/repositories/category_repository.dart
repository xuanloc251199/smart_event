import 'package:smart_event/models/category.dart';

import '../services/api_service.dart';

class CategoryRepository {
  final ApiService apiService;

  CategoryRepository(this.apiService);

  Future<List<Category>> getCategories() async {
    try {
      final response = await apiService.get('/categories');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
