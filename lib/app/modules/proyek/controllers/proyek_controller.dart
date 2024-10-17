import 'dart:convert';
import 'package:ems/app/data/kanban_provider.dart';
import 'package:ems/app/data/proyek_provider.dart';
import 'package:ems/app/modules/kanban/model_task.dart';
import 'package:ems/app/modules/proyek/model_proyek.dart';
import 'package:ems/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';

class ProyekController extends GetxController {
  var proyekList = <ProyekModel>[].obs;
  var isLoading = false.obs;
  var proyek = Rx<ProyekModel?>(null);

  void setProyek(ProyekModel? emp) {
    proyek.value = emp;
  }

  ProyekModel? ambilProyek() {
    return proyek.value;
  }

  void getProyek() async {
    try {
      isLoading(true);
      var fetchedAttendances = await ProyekProvider().fetchProyek();
      proyekList.assignAll(fetchedAttendances);
    } finally {
      isLoading(false);
    }
  }
}
