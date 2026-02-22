import 'package:family_budget/data/mock/mock_api_service.dart';
import 'package:family_budget/data/models/category.dart';

class CategoryRepository {
  final MockApiService _apiService = MockApiService();

  Future<List<Category>> getCategories() {
    return _apiService.getCategories();
  }

  Future<Category> addCategory(Category category) {
    return _apiService.addCategory(category);
  }

  Future<Category> updateCategory(Category category) {
    return _apiService.updateCategory(category);
  }

  Future<void> deleteCategory(String id) {
    return _apiService.deleteCategory(id);
  }
}
