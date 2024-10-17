import 'dart:convert';
class OfficeLocation {
  String latitude;
  String longitude;

  OfficeLocation({
    required this.latitude,
    required this.longitude,
  });

  factory OfficeLocation.fromJson(Map<String, dynamic> json) => OfficeLocation(
        latitude: json["latitude"],
        longitude: json["longitude"],
        
      );
}