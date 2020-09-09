class NotificationBloc {
  NotificationBloc({
    this.id,
    this.token,
    this.userId,
    this.notifcation,
  });

  int id;
  String token;
  int userId;
  List<Notifcation> notifcation;

  factory NotificationBloc.fromJson(Map<String, dynamic> json) =>
      NotificationBloc(
        id: json["id"],
        token: json["token"],
        userId: json["user_id"],
        notifcation: List<Notifcation>.from(
            json["notifcation"].map((x) => Notifcation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "user_id": userId,
        "notifcation": List<dynamic>.from(notifcation.map((x) => x.toJson())),
      };
}

class Notifcation {
  Notifcation({
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  int id;
  String title;
  String message;
  int isRead;
  DateTime createdAt;
  DateTime updatedAt;
  Pivot pivot;

  factory Notifcation.fromJson(Map<String, dynamic> json) => Notifcation(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        isRead: json["is_read"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "is_read": isRead,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    this.tokenId,
    this.notifcationId,
    this.isRead,
  });

  int tokenId;
  int notifcationId;
  int isRead;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        tokenId: json["token_id"],
        notifcationId: json["notifcation_id"],
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "token_id": tokenId,
        "notifcation_id": notifcationId,
        "is_read": isRead,
      };
}
