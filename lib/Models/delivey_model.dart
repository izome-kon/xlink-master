import 'package:beda3a/Models/user_model.dart';

class Delivery extends User {
  Delivery({
    this.id,
    this.userId,
  });

  int id;
  int userId;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json["id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
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

    super.delivery = this;
  }
}
