import 'package:flutter/foundation.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/repositories/food_repository.dart';

class FoodListProvider with ChangeNotifier {
  List<Food> _foods = [];
  bool _isLoading = true;

  List<Food> get foods => _foods;
  bool get isLoading => _isLoading;

  void updateFood(int id, Food newFood) {
    final index = _foods.indexWhere((food) => food.foodId == id);
    if (index != -1) {
      _foods[index].foodName = newFood.foodName;
      _foods[index].foodImage = newFood.foodImage;
      _foods[index].foodDescribe = newFood.foodDescribe;
      _foods[index].price = newFood.price;
      _foods[index].status = newFood.status;
      notifyListeners(); 
    }
  }
  void deleteFood(int id) {
    final index = _foods.indexWhere((food) => food.foodId == id);
    if (index != -1) {
      _foods.removeAt(index);
      notifyListeners(); 
    }
  }
  void addFood(Food food) {
      _foods.add(food);
      notifyListeners(); 
    }


  Future<void> fetchFoods(int merchantId) async {
    try {
      _foods = await FoodRepository().getAllByMerchant(merchantId);
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
}
