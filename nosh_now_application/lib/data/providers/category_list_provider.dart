import 'package:flutter/foundation.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/repositories/category_repository.dart';

class CategoryListProvider with ChangeNotifier {
  List<FoodCategory> _categories = [];
  bool _isLoading = true;

  List<FoodCategory> get categories => _categories;
  bool get isLoading => _isLoading;

  void updateCategory(int id, FoodCategory newCategory) {
    final index = _categories.indexWhere((category) => category.categoryId == id);
    if (index != -1) {
      _categories[index].categoryName = newCategory.categoryName;
      _categories[index].categoryImage = newCategory.categoryImage;
      notifyListeners(); 
    }
  }
  void deleteCategory(int id) {
    final index = _categories.indexWhere((category) => category.categoryId == id);
    if (index != -1) {
      _categories.removeAt(index);
      notifyListeners(); 
    }
  }
  void addCategory(FoodCategory category) {
      _categories.add(category);
      notifyListeners(); 
    }


  Future<void> fetchCategories() async {
    try {
      _categories = await CategoryRepository().getAll();
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
}
