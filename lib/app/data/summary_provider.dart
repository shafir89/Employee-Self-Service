import 'dart:convert';

import 'package:ems/app/modules/absensi/model_absensi.dart';
import 'package:ems/app/modules/home/model_summary.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';

class SummaryProvider {
  Future<Data> fetchSummary() async {
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
      final data = jsonData['data'] as Map<String, dynamic>;
      return Data.fromJson(data);
    } else {
      throw Exception('Failed to load attendances');
    }
  }
}
