import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/data/repositories/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoriesProvider =
    NotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>(
        CategoryNotifier.new);

class CategoryNotifier extends Notifier<AsyncValue<List<Category>>> {
  late final CategoryRepository _repository;

  @override
  AsyncValue<List<Category>> build() {
    _repository = ref.watch(categoryRepositoryProvider);
    loadCategories();
    return const AsyncValue.loading();
  }

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _repository.getCategories();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> addCategory(Category category) async {
    try {
      await _repository.addCategory(category);
      await loadCategories();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateCategory(Category category) async {
    try {
      await _repository.updateCategory(category);
      await loadCategories();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
      await loadCategories();
      return true;
    } catch (_) {
      return false;
    }
  }
}
