import 'package:ems/app/modules/kanban/controllers/kanban_controller.dart';
import 'package:ems/app/modules/login/controllers/login_controller.dart';
import 'package:ems/app/modules/notifikasi/controllers/notifikasi_controller.dart';
import 'package:ems/app/modules/proyek/controllers/proyek_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  // var idkanban = SpUtil.getInt('idKnaban');
  Get.put(ProyekController());
  Get.put(LoginController());
  // KanbanController().getKomentar(idkanban!);
  ProyekController().getProyek();
  NotifikasiController().getNotif();
  

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Helvetica",
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Menggunakan biru sebagai warna utama
          accentColor: Colors.lightBlueAccent, // Warna aksen (secondary)
          backgroundColor: Colors.white, // Warna latar belakang
          errorColor: Colors.red,
        ),
      ),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
