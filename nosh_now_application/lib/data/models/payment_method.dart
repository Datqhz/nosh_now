class PaymentMethod {
  int methodId;
  String methodName;
  String methodImage;
  PaymentMethod({required this.methodId, required this.methodName, required this.methodImage});
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(methodId: json['id'], methodName: json['methodName'], methodImage: json['methodImage']);
  }
}
