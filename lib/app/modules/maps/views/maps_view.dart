import 'dart:math';

import 'package:ems/app/data/absen_provider.dart';
import 'package:ems/app/modules/home/controllers/home_controller.dart';
import 'package:ems/app/modules/login/controllers/login_controller.dart';
import 'package:ems/app/modules/login/lokasi_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';

class MapsView extends StatefulWidget {
  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final lokasicontroller = Get.find<LoginController>();

  // LatLng officeLocation = LatLng(-7.9446641, 112.6550323); // Koordinat kantor
  // LatLng officeLocation = LatLng(-7.3397008,112.748955); // Koordinat kantor
  LatLng? userLocation;
  bool isUserInPolygon = false;

  bool isUserInCircle = false;

  // // Koordinat polygon kantor
  // List<LatLng> officePolygon = [
  //   LatLng(-6.200500, 106.815500),
  //   LatLng(-6.201000, 106.816500),
  //   LatLng(-6.200800, 106.817500),
  //   LatLng(-6.200300, 106.818000),
  //   LatLng(-6.199800, 106.817000),
  //   LatLng(-6.199500, 106.816000),
  // ];

  @override
  void initState() {
    final lokasi = lokasicontroller.getLocation();
    var latitude = double.parse(lokasi!.latitude);
    var longitude = double.parse(lokasi.longitude);
    LatLng officeLocation = LatLng(latitude, longitude);
    super.initState();
    _getUserLocation(officeLocation);
  }

  double circleRadius = 30; // Radius dalam meter
  Future<void> _getUserLocation(officeLocation) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Layanan lokasi dinonaktifkan, silakan aktifkan!'),
      ));
      return;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Izin lokasi ditolak!'),
        ));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Izin lokasi ditolak permanen!'),
      ));
      return;
    }

    // Mendapatkan lokasi user saat ini dengan LocationSettings
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // Minimum distance before updates are emitted
    );
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    setState(() {
      // userLocation = LatLng(position.latitude, position.longitude);
      userLocation = LatLng(-7.896952026414202, 112.59814739227296);
      if (userLocation != null) {
        double distance = _euclideanDistance(userLocation!, officeLocation);
        isUserInCircle = distance <= circleRadius;
        print(isUserInCircle);
      } else {
        print('user nya null');
      }
    });
  }

  double _distanceBetween(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // radius in meters
    final double dLat = _toRadians(point2.latitude - point1.latitude);
    final double dLon = _toRadians(point2.longitude - point1.longitude);
    final double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_toRadians(point1.latitude)) *
            cos(_toRadians(point2.latitude)) *
            (sin(dLon / 2) * sin(dLon / 2)));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // distance in meters
  }

  double _euclideanDistance(LatLng point1, LatLng point2) {
    // Konversi latitude dan longitude ke meter
    double x = (point2.longitude - point1.longitude) *
        111320 *
        cos(point1.latitude * pi / 180);
    double y = (point2.latitude - point1.latitude) * 110540;
    return sqrt(x * x + y * y); // Jarak dalam meter
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    final lokasi = lokasicontroller.getLocation();
    var latitude = double.parse(lokasi!.latitude);
    var longitude = double.parse(lokasi.longitude);
    LatLng officeLocation = LatLng(latitude, longitude);
    print(latitude);
    print(longitude);
    return Scaffold(
        appBar: AppBar(
          title: Text("Peta Lokasi"),
        ),
        body: userLocation == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FlutterMap(
                // mapController: ,
                options: MapOptions(
                  initialCenter: officeLocation,
                  initialZoom: 15.0,
                ),
                // maxZoom: 16.0),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png", // Use without subdomains
                  ),
                  // CircleLayer(
                  //   circles: [
                  //     CircleMarker(
                  //       point: officeLocation, // Center of the circle
                  //       color: Colors.blue.withOpacity(0.3),
                  //       borderStrokeWidth: 2.0,
                  //       borderColor: Colors.blue,
                  //       radius: 50, // Radius in meters
                  //     ),
                  //   ],
                  // ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: officeLocation,
                        radius: circleRadius,
                        color: Colors.blue.withOpacity(0.3),
                        borderStrokeWidth: 2.0,
                        borderColor: Colors.blue,
                        useRadiusInMeter: true,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: officeLocation,
                        child: Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.red),
                            Text(
                              'Kantor',
                            )
                          ],
                        ), // Ganti builder menjadi child

                        width: 40,
                        height: 40,
                      ),
                      if (userLocation != null)
                        Marker(
                          point: userLocation!,

                          child: Column(
                            children: [
                              Icon(Icons.person_pin_circle,
                                  color: Colors.green),
                              Text('Anda')
                            ],
                          ), // Ganti builder menjadi child
                          width: 40,
                          height: 40,
                        ),
                    ],
                  ),
                ],
              ),
        bottomSheet: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isUserInCircle
                    ? Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Absen dapat dilakukan',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              'Anda berada di lingkungan kantor',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[850]),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Absen tidak dapat dilakukan',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              'Anda berada di luar lingkungan kantor',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[850]),
                            ),
                          ],
                        ),
                      )
              ],
            ),
            isUserInCircle
                ? SizedBox()
                : Row(
                    mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _getUserLocation(officeLocation);
                          isUserInCircle;
                        },
                        child: Text(
                          'Update Lokasi',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                      ),
                      // Add other children here
                    ],
                  )
          ],
        ),
        floatingActionButton: isUserInCircle
            ? FloatingActionButton(
                onPressed: () async {
                  HomeController().getCurrentPosition();
                  AbsenService().AbsenRequest();
                  Get.back();
                },
                child: Icon(Icons.fingerprint),
              )
            : null
        // : FloatingActionButton(
        //     backgroundColor: Colors.grey,
        //     enableFeedback: false,
        //     onPressed: () {},
        //     child: Icon(
        //       Icons.fingerprint,
        //       color: Colors.grey[800],
        //     ),
        //   ),
        );
  }
}
