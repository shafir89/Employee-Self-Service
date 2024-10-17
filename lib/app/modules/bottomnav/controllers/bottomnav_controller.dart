import 'package:ems/app/modules/absensi/views/absensi_view.dart';
import 'package:ems/app/modules/home/views/home_view.dart';
import 'package:ems/app/modules/notifikasi/views/notifikasi_view.dart';
import 'package:ems/app/modules/proyek/views/proyek_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BottomnavController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    HomeView(),
    AbsensiView(),
    NotifikasiView(),
    ProyekView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  void handleNavigationChange(int index) {
    currentIndex.value = index;
  }
}
