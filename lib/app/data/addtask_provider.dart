import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

class AddTask extends GetConnect {
  Future<Response> addTask(var data) {
    var token = SpUtil.getString('token');
    var myHeader = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    return post('http://127.0.0.1:8000/api/kanban-task', data,
        headers: myHeader);
  }
}
