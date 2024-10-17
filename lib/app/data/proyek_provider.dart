import 'dart:convert';

import 'package:ems/app/modules/proyek/model_proyek.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:http/http.dart'as http;

class ProyekProvider extends GetConnect {


  Future<List<ProyekModel>> fetchProyek() async {
    var token = SpUtil.getString('token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/projects'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List projects = jsonData['project'];

      return projects
          .map((project) => ProyekModel.fromJson(project))
          .toList();
    } else {
      throw Exception('Failed to load attendances');
    }
  }
}



