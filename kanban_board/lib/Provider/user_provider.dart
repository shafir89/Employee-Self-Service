import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

class UserProvider extends GetConnect {
  Future<List<UserAssignModel>> fetchUser(int id) async {
  // Future<List<UserAssignModel>> fetchUser(int id) async {
    var token = SpUtil.getString('token');
    print(token);
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(
      // Uri.parse('http://127.0.0.1:8000/api/kanban-board?id=9'),
      Uri.parse('http://127.0.0.1:8000/api/kanban-board?id=$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(response.body);
      List dataUser = jsonData['data']['users'];
      print(dataUser);
      // Mengambil semua assigned_projects dari setiap project

      return dataUser.map((user) => UserAssignModel.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load attendances');
    }
  }
}

class UserAssignModel {
  final int idEmployee;
  final String nameEmployee;

  UserAssignModel({
    required this.idEmployee,
    required this.nameEmployee,
  });

  factory UserAssignModel.fromJson(Map<String, dynamic> json) {
    return UserAssignModel(
      idEmployee: json['id'],
      nameEmployee: json['name'],
    );
  }
}
