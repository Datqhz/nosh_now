class FoodCategory {
  int categoryId;
  String categoryName;
  String categoryImage;
  FoodCategory({required this.categoryId, required this.categoryName, required this.categoryImage});
  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(categoryId: json['id'], categoryName: json['categoryName'], categoryImage: json['categoryImage']);
  }
}
