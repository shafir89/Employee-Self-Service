import 'package:get/get.dart';

class NotifModel {
  String id;
  int notifiableId;
  String readAt;
  String createdAt;
  String title;
  String message;
  String type;

  NotifModel({
    required this.id,
    required this.notifiableId,
    required this.readAt,
    required this.createdAt,
    required this.title,
    required this.message,
    required this.type,
  });

  factory NotifModel.fromJson(Map<String, dynamic> json) {
    return NotifModel(
      id: json['id']??'',
      notifiableId: json['notifiable_id ']??0,
      readAt: json['read_at']?? '',
      createdAt: json['created_at']??'',
      title: json['data']['title']??'',
      message: json['data']['message']??'',
      type: json['data']['type']??'',
    );
  }
}
