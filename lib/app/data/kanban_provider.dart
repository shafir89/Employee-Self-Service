import 'dart:convert';

import 'package:ems/app/modules/kanban/model_kometar.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:http/http.dart' as http;

class KanbanProvider extends GetConnect {
  var token = SpUtil.getString('token');
  Future<Response> getKanban(int idProyek) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // Create the URL with query parameters
    var uri = Uri.parse('http://127.0.0.1:8000/api/kanban-board').replace(
      queryParameters: {'id': idProyek.toString()},
    );

    // Perform the GET request
    var response = await http.get(uri, headers: headers);

    // Convert the response to GetConnect's Response type

    return Response(
      bodyString: response.body,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
  }

  Future<KomentarModel> fetchComments(int id) async {
  var headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/kanban-board?id=$id'),
      headers: headers);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    
    // Parse bagian comments menjadi objek KomentarModel
    var komentar = KomentarModel.fromJson(jsonResponse['data']);
    
    // Menyimpan total komentar
    int totalComment = komentar.comments.commentCount;
    SpUtil.putInt('total_komen', totalComment);

    // Kembalikan daftar komentar
    return komentar;
  } else {
    throw Exception('Failed to load comments');
  }
}

}
