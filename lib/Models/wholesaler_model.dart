import 'package:beda3a/Models/user_model.dart';

class Wholesaler extends User {
  Wholesaler({
    this.id,
    this.userId,
    this.deliveryAvailability,
    this.location,
    this.score,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int id;
  int userId;
  int deliveryAvailability;
  String location;
  int score;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory Wholesaler.fromJson(Map<String, dynamic> json) {
    return Wholesaler(
      id: json["id"],
      userId: json["user_id"],
      deliveryAvailability: json["delivery_availability"],
      location: json["location"],
      score: json["score"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "delivery_availability": deliveryAvailability,
        "location": location,
        "score": score,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  @override
  userFromJson(Map<String, dynamic> json) {
    super.userId = json["id"];
    super.roleId = json["role_id"];
    super.userName = json["name"];
    super.avatar = json["avatar"];
    super.phone = json["phone"];
    super.phoneVerifiedAt = json["phone_verified_at"];

    super.active = json["active"];
    super.onlineCounter = json["online_counter"];
    super.createdAt =
        json["created_at"] != null ? DateTime.parse(json["created_at"]) : null;
    super.updatedAt =
        json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null;

    super.wholesaler = this;
  }
}
