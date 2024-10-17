import 'dart:convert';

import 'package:ems/app/modules/absensi/model_absensi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';

class AbsenService extends GetConnect {
  Future<List<Attendance>> fetchAbsensi() async {
    var token = SpUtil.getString('token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/user-attendance'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List attendances = jsonData['data']['attendances'];

      return attendances
          .map((attendance) => Attendance.fromJson(attendance))
          .toList();
    } else {
      throw Exception('Failed to load attendances');
    }
  }


  Future AbsenRequest() async {
    var token = SpUtil.getString('token');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('http://127.0.0.1:8000/api/user-attendance'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('hadir');
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody); // Parse JSON
      String message = jsonResponse['message'];
      Get.snackbar('Success', message);
    }
    if (response.statusCode == 201) {
      print('hadir');
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody); // Parse JSON
      String message = jsonResponse['message'];
      Get.snackbar('Success', message,backgroundColor: Colors.green, colorText: Colors.white);
    }
    
     else {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody); // Parse JSON
      String message = jsonResponse['message'];
      // Get.snackbar('Success', message,backgroundColor: Colors.green,colorText: Colors.white);

      Get.snackbar('Absen belum dimulai', message,
          backgroundColor: Colors.red, colorText: Colors.white);
      print(response.reasonPhrase);
    }
  }

  
}





