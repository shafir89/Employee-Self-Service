import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kanban_board/Provider/board_list_provider.dart';
import 'package:kanban_board/Provider/user_provider.dart';
import 'package:sp_util/sp_util.dart';

class StoreTaskProvider extends GetConnect {
  Future<Response> storeTask(data) async {
    var token = SpUtil.getString('token');
    print(token);
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    return post('http://127.0.0.1:8000/api/kanban-task', data,
        headers: headers);
  }

  void store(title, description, date, color, employee_id, status,
      kanban_boards_id) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      var data =
          // 'title': title,
          // 'description': description,
          // 'date': date,
          // 'color': color,
          // 'employee_id': employee_id

          json.encode({
        // 'title': 'Task Title asdasd',
        // 'description': 'This is a sample task description.',
        // 'status': 'todo',
        // 'kanban_boards_id': 5,
        // 'date': '2024-09-09',
        // 'color': '#ff0000',
        // 'employee_id': 2
        'title': title,
        'description': description,
        'date': formattedDate,
        'color': color,
        'employee_id': employee_id,
        'status': status,
        'kanban_boards_id': kanban_boards_id,
      });

      var response = await StoreTaskProvider().storeTask(data);

      if (response.statusCode == 200) {
        //   Get.snackbar('Success', 'Login Berhasil',
        //       colorText: Colors.white, backgroundColor: Colors.green);

        //   // var token = response.body['access_token'];
        //   // EmployeeModel employee =
        //   //     EmployeeModel.fromJson(response.body['user']);

        //   if (token != null) {
        //     SpUtil.putString('token', token);
        //     Get.find<LoginController>().setEmployee(employee);

        //     Get.offAllNamed(Routes.BOTTOMNAV);
        //   } else {
        //     loading.value = false;
        //     Get.snackbar('Error', 'Token tidak ditemukan dalam respons',
        //         colorText: Colors.white, backgroundColor: Colors.red);
        //   }
        // } else if (response.statusCode == 401) {
        //   loading.value = false;
        //   Get.snackbar('Error', 'Email atau Password Salah',
        //       colorText: Colors.white, backgroundColor: Colors.red);
        // } else {
        //   loading.value = false;
        //   Get.snackbar(
        //       'Error', 'Login Gagal, kode status: ${response.statusCode}',
        //       colorText: Colors.white, backgroundColor: Colors.red);
        print(response.body);
        
      }
      print(response.body);
    } catch (e) {
      // loading.value = false;

      // Get.snackbar('Error', 'Terjadi kesalahan',
      // colorText: Colors.white, backgroundColor: Colors.red);
      print(e);
    }
  }
}
