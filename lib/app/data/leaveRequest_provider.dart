
import 'package:sp_util/sp_util.dart';





  
  import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class LeaverequestProvider {
  Future<http.Response> LeaveRequest(Map<String, dynamic> data, File? imageFile) async {
    String? token = SpUtil.getString('token');
    
    var uri = Uri.parse('http://127.0.0.1:8000/api/leave-request');

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

    // Add form fields
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add file if exists
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'photo',
        stream,
        length,
        filename: basename(imageFile.path),
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);
    }

    var response = await request.send();
    return await http.Response.fromStream(response);
  }
}
