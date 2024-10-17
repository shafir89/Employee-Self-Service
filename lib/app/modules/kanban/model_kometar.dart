import 'dart:convert';

KomentarModel komentarModelFromJson(String str) => KomentarModel.fromJson(json.decode(str));

String komentarModelToJson(KomentarModel data) => json.encode(data.toJson());

class KomentarModel {
    Comments comments;

    KomentarModel({
        required this.comments,
    });

    factory KomentarModel.fromJson(Map<String, dynamic> json) => KomentarModel(
        comments: Comments.fromJson(json["comments"]),
    );

    Map<String, dynamic> toJson() => {
        "comments": comments.toJson(),
    };
}

class Comments {
    List<Datum> data;
    int commentCount;

    Comments({
        required this.data,
        required this.commentCount,
    });

    factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        commentCount: json["comment_count"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "comment_count": commentCount,
    };
}

class Datum {
    int id;
    int projectId;
    int userId;
    int? parentId;
    String comment;
    DateTime createdAt;
    DateTime updatedAt;
    List<Datum>? replies;
    User? user;

    Datum({
        required this.id,
        required this.projectId,
        required this.userId,
        required this.parentId,
        required this.comment,
        required this.createdAt,
        required this.updatedAt,
        this.replies,
        this.user,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        projectId: json["project_id"],
        userId: json["user_id"],
        parentId: json["parent_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        replies: json["replies"] == null ? [] : List<Datum>.from(json["replies"]!.map((x) => Datum.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "project_id": projectId,
        "user_id": userId,
        "parent_id": parentId,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
        "user": user?.toJson(),
    };
}

class User {
    int id;
    int companyId;
    String name;
    String email;
    dynamic emailVerifiedAt;
    DateTime createdAt;
    DateTime updatedAt;

    User({
        required this.id,
        required this.companyId,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}