import 'package:ems/app/modules/kanban/model_kometar.dart';
import 'package:ems/app/modules/kanban/model_task.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:ems/app/data/kanban_provider.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

class KanbanController extends GetxController {
  var loading = false.obs;
  var todoList = <Task>[].obs;
  var inProgressList = <Task>[].obs;
  var doneList = <Task>[].obs;
  
  final judul = TextEditingController();
  final deskripsi = TextEditingController();
  Rxn<DateTime> tanggalSelesai = Rxn<DateTime>(); // Bisa null
  final formKey = GlobalKey<FormState>();
  var id = SpUtil.getInt('idKanban');
var komentar = Rxn<KomentarModel>(); // Ini untuk menyimpan komentar yang diambil

  // Mendapatkan komentar
  Future<void> getKomentar(int id) async {
    try {
      KomentarModel fetchedKomentar = await KanbanProvider().fetchComments(id);
      komentar.value = fetchedKomentar; // Set nilai komentar
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    var id = SpUtil.getInt('idKanban');
    if (id != null) {
      await getKanban(id);
      await getKomentar(id);  // Ambil komentar saat init
    }
  }


  Future<void> getKanban(int id) async {
    loading.value = true;
    try {
      var response = await KanbanProvider().getKanban(id);
      if (response.statusCode == 200) {
        var body = response.bodyString;
        if (body != null && body.isNotEmpty) {
          var jsonResponse = json.decode(body);
          var list = jsonResponse['data']['tasks'] as Map<String, dynamic>?;

          if (list != null) {
            todoList.value = (list['todo'] as List<dynamic>)
                .map((taskData) =>
                    Task.fromMap(taskData as Map<String, dynamic>))
                .toList();
            inProgressList.value = (list['progress'] as List<dynamic>)
                .map((taskData) =>
                    Task.fromMap(taskData as Map<String, dynamic>))
                .toList();
            doneList.value = (list['done'] as List<dynamic>)
                .map((taskData) =>
                    Task.fromMap(taskData as Map<String, dynamic>))
                .toList();

            // Print lists to verify
            print("To Do List: $todoList");
            print("In Progress List: $inProgressList");
            print("Done List: $doneList");
            // await getKomentar(id);
            // Ensure to navigate after data is set
            // Get.toNamed(Routes.KANBAN);
            loading.value = false;
            return Get.toNamed(Routes.KANBAN, arguments: {
              'todoList': todoList,
              'inProgressList': inProgressList,
              'doneList': doneList
            });
          } else {
            // print("No 'kanban_tasks' key found in response.");
          }
        } else {
          print("Response body is null or empty.");
        }
      } else {
        print("Error ${response.statusCode}: ${response.statusText}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      loading.value = false;
    }
  }

  // Future<void> getKomentar(int id) async {
  //   loading.value = true;
  //   try {
  //     var response = await KanbanProvider().getKanban(id);
  //     if (response.statusCode == 200) {
  //       var body = response.bodyString;
  //       if (body != null && body.isNotEmpty) {
  //         var jsonResponse = json.decode(body);
  //         var totalKomentar = jsonResponse['data']['comments']['comment_count'];

  //         Comment komentar = Comment.fromJson(
  //             jsonResponse['data']['comments']['comment_count']);

  //         print(komentar);
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }
}
