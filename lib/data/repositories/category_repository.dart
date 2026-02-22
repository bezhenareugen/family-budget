import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/data/remote/api_service.dart';
import 'package:flutter/material.dart';

class CategoryRepository {
  final ApiService _api;

  CategoryRepository(this._api);

  Future<List<Category>> getCategories() async {
    return _api.get<List<Category>>(
      '/api/categories',
      fromJson: (json) => (json as List)
          .map((j) => _fromApiJson(j as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Category> addCategory(Category category) async {
    return _api.post<Category>(
      '/api/categories',
      body: _toApiJson(category),
      fromJson: (json) => _fromApiJson(json as Map<String, dynamic>),
    );
  }

  Future<Category> updateCategory(Category category) async {
    return _api.put<Category>(
      '/api/categories/${category.id}',
      body: _toApiJson(category),
      fromJson: (json) => _fromApiJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteCategory(String id) => _api.delete('/api/categories/$id');

  // API uses iconCodePoint + colorValue ints, matching Flutter model
  static Map<String, dynamic> _toApiJson(Category c) => {
        'name': c.name,
        'iconCodePoint': c.icon.codePoint,
        'colorValue': c.color.toARGB32(),
      };

  static Category _fromApiJson(Map<String, dynamic> j) => Category(
        id: j['id'] as String,
        name: j['name'] as String,
        icon: IconData(j['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
        color: Color(j['colorValue'] as int),
      );
}
