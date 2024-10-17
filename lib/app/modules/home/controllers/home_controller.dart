import 'dart:async';

import 'package:ems/app/data/absen_provider.dart';
import 'package:ems/app/data/login_provider.dart';
import 'package:ems/app/data/summary_provider.dart';
import 'package:ems/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:ems/app/modules/absensi/model_absensi.dart';
import 'package:ems/app/modules/home/model_summary.dart';
import 'package:ems/app/modules/home/views/dashboard.dart';
import 'package:ems/app/modules/login/controllers/login_controller.dart';
import 'package:ems/app/modules/proyek/controllers/proyek_controller.dart';
import 'package:ems/app/modules/proyek/model_proyek.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ProyekController proyekController = Get.find<ProyekController>();
  var tiles = <TileData>[].obs;
  var summaryData = Rx<Data?>(null);
  DateTime today = DateTime.now();
  Timer? _timer;
  var filteredProyekList = <ProyekModel>[].obs;
  var isLoading = true.obs;
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    // setState(() {});
  }

  Future<void> checkAndRequestGPS() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Memeriksa apakah layanan lokasi sudah aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika layanan lokasi belum aktif, minta pengguna untuk menyalakannya
      Get.snackbar('info', 'Mohon aktifkan GPS Anda ');

      // Membuka pengaturan lokasi
      serviceEnabled = await Geolocator.openLocationSettings();
      getCurrentPosition();

      // Jika pengguna tidak mengaktifkan GPS, hentikan proses
      if (!serviceEnabled) {
        return;
      }
      if (serviceEnabled) {
        getCurrentPosition();
      }
    }

    // 2. Jika GPS sudah aktif, periksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Izin ditolak oleh pengguna
        // Get.snackbar('info', 'Perlu izin lokasi');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Izin lokasi secara permanen ditolak
      // Get.snackbar('info', 'Izin lokasi permanen');
      return;
    }

    // Lanjutkan jika layanan lokasi dan izin sudah diberikan
    if (serviceEnabled && permission != LocationPermission.denied) {
      // Get.snackbar('info', 'gps sudah aktif');
      // Lakukan aksi selanjutnya yang membutuhkan akses lokasi di sini
    }

    if (permission == LocationPermission.deniedForever) {
      // Izin lokasi secara permanen ditolak
      // Get.snackbar('error', 'Izin lokasi telah ditolak secara permanen');
    }

    // Lanjutkan jika layanan lokasi dan izin sudah diberikan
    if (serviceEnabled && permission != LocationPermission.denied) {
      print("GPS telah aktif dan izin lokasi telah diberikan.");
      getCurrentPosition();
    }
  }

  Future<void> getCurrentPosition() async {
    isLoading(true);
    try {
      final hasPermission = await _handlePermission();

      if (!hasPermission) {
        isLoading(false);
        return;
      }

      final position = await _geolocatorPlatform.getCurrentPosition();
      _updatePositionList(
        _PositionItemType.position,
        position.toString(),
      );
      isLoading(false);
      print(position.toString());
      // await AbsenService().AbsenRequest();
      // fetchAttendances();
      // SummaryProvider().fetchSummary();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  // Metode untuk memperbarui proyekList
  void updateProyekList(List<ProyekModel> newList) {
    proyekController.proyekList.value = newList;
    filterProyek();
  }

  // Metode untuk memfilter proyek
  void filterProyek() {
    filteredProyekList.value = proyekController.proyekList.where((proyek) {
      DateTime endDate = proyek.end_date; // Pastikan end_date adalah DateTime
      return endDate.day == today.day &&
          endDate.month == today.month &&
          endDate.year == today.year;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
    _startPolling();
    fetchAttendances();
    proyekController.getProyek();
    filterProyek();

    // checkAndRequestGPS();
  }

  var attendances = <Attendance>[].obs; // List observable dari Attendance

  void fetchAttendances() async {
    try {
      isLoading(true);
      var fetchedAttendances = await AbsenService().fetchAbsensi();
      attendances.assignAll(
          fetchedAttendances); // Menyimpan attendances ke list observable
      AbsensiController().fetchAttendances();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    _timer?.cancel(); // Hentikan polling ketika controller dihancurkan
    super.onClose();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      fetchSummary(); // Ambil data setiap 30 detik
    });
  }

  Future<void> fetchSummary() async {
    try {
      final data = await SummaryProvider().fetchSummary();
      summaryData.value = data; // Update observasi data summary

      int hadirDanTelat = data.totalPresent + data.totalLate;
      tiles.value = [
        TileData(data.totalAttendance.toString(), 'Total Absensi',
            Color.fromARGB(255, 93, 135, 255)),
        // TileData(data.totalAttendance.toString(), 'Total Absen', Color.fromARGB(255,24, 79, 235)),
        TileData(hadirDanTelat.toString(), 'Hadir',
            Color.fromARGB(255, 20, 168, 141)),
        // TileData(data.totalLate.toString(), 'Terlambat', Colors.green),
        TileData(data.totalAlpha.toString(), 'Alpha',
            const Color.fromARGB(255, 250, 137, 107)),
        TileData(data.totalAbsent.toString(), 'Izin & Sakit',
            Color.fromARGB(255, 255, 174, 31)),
      ];
    } catch (e) {
      print('Error fetching summary: $e');
    }
  }

  Future<void> dialogBuilder(BuildContext context) {
    final employeeController = Get.find<LoginController>();
    final employee = employeeController.getEmployee();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profil Pengguna'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                maxRadius: 30,
                backgroundImage: AssetImage(
                  'assets/images/avauser.png',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Text(
                    employee!.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  Text(
                    employee.email,
                    style: TextStyle(fontSize: 15),
                  ),
                  // Text('employee',style: TextStyle(fontSize: 15),),
                  // Text(employee.companyId.toString(),style: TextStyle(fontSize: 15),),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        backgroundColor:
                            const Color.fromARGB(255, 252, 231, 231),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Anda Yakin Ingin Keluar?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Tidak',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await LoginProvider().logoutRequest();
                                    },
                                    child: const Text(
                                      'Ya',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 24, 79, 235)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

enum _PositionItemType {
  log,
  position,
}
