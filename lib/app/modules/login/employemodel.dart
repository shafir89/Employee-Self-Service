import 'dart:convert';

// EmployeeModel employeeModelFromJson(String str) =>
    // EmployeeModel.fromJson(json.decode(str));

// String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  String name;
  String email;
  String guardName;
  String addressComp;
  String contactComp;
  String nameComp;
  String role;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.guardName,
    required this.addressComp,
    required this.contactComp,
    required this.nameComp,
    required this.role,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        name: json["name"],
        email: json["email"],
        guardName: json["roles"][0]["guard_name"],
        nameComp: json["company"]["name"],
        addressComp: json["company"]["address"],
        contactComp: json["company"]["contact_email"],
        role: json["roles"][0]["name"],
        
      );
}
