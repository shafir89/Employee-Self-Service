import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ems/app/modules/notifikasi/model_notif.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

class NotifikasiProvider extends GetConnect {
  Future<List<NotifModel>> fetchNotif() async {
    var token = SpUtil.getString('token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/notifications'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List notifikasi = jsonData['notifications'];
      print(jsonData['new_notifiaction_count']);
      print(response.body);
      print(notifikasi[0]['id']);

      SpUtil.putString(
          'totalNotif', jsonData['new_notifiaction_count'].toString());

      // 'totalNotif', jsonData['new_notifiaction_count'].toString());
      print(notifikasi.length);
      return notifikasi.map((notif) => NotifModel.fromJson(notif)).toList();
    } else {
      throw Exception('Failed to load attendances');
    }
  }

  Future<void> deleteNotif(id) async {
    var token = SpUtil.getString('token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/notifications/$id'),
      headers: headers,
    );
    var jsonResponse = jsonDecode(response.body);
    String message = jsonResponse['message'];

    if (response.statusCode == 200) {
      Get.snackbar('Success', message);
    } else {
      Get.snackbar('Error', message);
      print(message);
    }
  }
}
