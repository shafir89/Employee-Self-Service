import 'dart:convert';
import 'dart:math';

import 'package:ems/app/modules/absensi/model_absensi.dart';
import 'package:ems/app/modules/login/controllers/login_controller.dart';
import 'package:ems/app/modules/login/lokasi_model.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';

class LoginProvider extends GetConnect {
  var token = SpUtil.getString('token');
  Future<Response> auth(var data) {
    var myHeader = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    return post('http://127.0.0.1:8000/api/auth/login', data,
        headers: myHeader);
  }

  Future logoutRequest() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'POST', Uri.parse('http://127.0.0.1:8000/api/auth/logout'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody); // Parse JSON
      String message = jsonResponse['message'];

      Get.offAllNamed(Routes.LOGIN);
    } else {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody); // Parse JSON
      print(response.reasonPhrase);
      String message = jsonResponse['message'];

      Get.snackbar('Gagal', message);
    }
  }

  Future getLocation() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var request = http.Request(
        'GET', Uri.parse('http://127.0.0.1:8000/api/company-location'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      var json = jsonDecode(body);
      print(json);
      OfficeLocation lokasi = OfficeLocation.fromJson(json['location']);
      Get.find<LoginController>().setLocation(lokasi);
      Get.snackbar('Success', 'Berhasil mendapatkan lokasi kantor',
          backgroundColor: Colors.blue, colorText: Colors.white);
    } else {
      print(response.reasonPhrase);
    }
  }
}
