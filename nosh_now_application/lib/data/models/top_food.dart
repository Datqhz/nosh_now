class TopFood{
  int foodId;
  String foodName;
  int quantity;
  double revenue;
  TopFood({required this.foodId, required this.foodName,  required this.quantity, required this.revenue});
  factory TopFood.fromJson(Map<String, dynamic> json){
    return TopFood(foodId: json['foodId'], foodName: json['foodName'],quantity: json['quantity'], revenue: json['revenue']/1.0);
  }
}