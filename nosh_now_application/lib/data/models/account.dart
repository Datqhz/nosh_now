import 'package:nosh_now_application/data/models/role.dart';

class Account {
  int accountId;
  String email;
  Role? role;
  Account({required this.accountId, required this.email, this.role});
  factory Account.fromJson(Map<dynamic, dynamic> json) {
    return Account(
        accountId: json['id'],
        email: json['email'],
        role: json['role'] != null ? Role.fromJson(json['role']) : null);
  }
}
