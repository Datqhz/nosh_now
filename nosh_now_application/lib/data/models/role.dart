class Role {
  int roleId;
  String roleName;
  Role({required this.roleId, required this.roleName});
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(roleId: json['id'], roleName: json['roleName']);
  }
}
