import 'package:family_budget/data/local/local_storage_service.dart';
import 'package:family_budget/data/models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryRepository {
  final LocalStorageService _storage;
  static const _uuid = Uuid();

  CategoryRepository(this._storage);

  Future<List<Category>> getCategories() async {
    final jsonList = _storage.getCategories();
    return jsonList.map((j) => Category.fromJson(j)).toList();
  }

  Future<Category> addCategory(Category category) async {
    final newCategory = category.copyWith(id: _uuid.v4());

    final jsonList = _storage.getCategories();
    jsonList.add(newCategory.toJson());
    await _storage.saveCategories(jsonList);

    return newCategory;
  }

  Future<Category> updateCategory(Category category) async {
    final jsonList = _storage.getCategories();
    final index = jsonList.indexWhere((j) => j['id'] == category.id);
    if (index == -1) throw Exception('Category not found');

    jsonList[index] = category.toJson();
    await _storage.saveCategories(jsonList);
    return category;
  }

  Future<void> deleteCategory(String id) async {
    final jsonList = _storage.getCategories();
    jsonList.removeWhere((j) => j['id'] == id);
    await _storage.saveCategories(jsonList);
  }
}
