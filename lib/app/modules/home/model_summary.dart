// To parse this JSON data, do
//
//     final allAbsenModel = allAbsenModelFromJson(jsonString);

import 'dart:convert';

AllAbsenModel allAbsenModelFromJson(String str) => AllAbsenModel.fromJson(json.decode(str));

String allAbsenModelToJson(AllAbsenModel data) => json.encode(data.toJson());

class AllAbsenModel {
    Data data;

    AllAbsenModel({
        required this.data,
    });

    factory AllAbsenModel.fromJson(Map<String, dynamic> json) => AllAbsenModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    int totalAttendance;
    int totalPresent;
    int totalAbsent;
    int totalAlpha;
    int totalLate;

    Data({
        required this.totalAttendance,
        required this.totalPresent,
        required this.totalAbsent,
        required this.totalAlpha,
        required this.totalLate
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalAttendance: json["total_attendance"],
        totalPresent: json["total_present"],
        totalAbsent: json["total_absent"],
        totalAlpha: json["total_alpha"],
        totalLate: json["total_late"],
    );

    Map<String, dynamic> toJson() => {
        "total_attendance": totalAttendance,
        "total_present": totalPresent,
        "total_absent": totalAbsent,
        "total_alpha": totalAlpha,
        "total_late": totalLate,
    };
}



// class CekAbsen {
//   DateTime createdAt;

//   CekAbsen({required this.createdAt});

//   factory CekAbsen.fromJson(Map<String, dynamic> json) {
//     return CekAbsen(
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }
