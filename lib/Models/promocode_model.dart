class Promocode {
  Promocode({
    this.id,
    this.code,
    this.discount,
    this.endDate,
    this.required,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String code;
  dynamic discount;
  DateTime endDate;
  dynamic required;
  DateTime createdAt;
  DateTime updatedAt;

  factory Promocode.fromJson(Map<String, dynamic> json) => Promocode(
        id: json["id"],
        code: json["code"],
        discount: json["discount"],
        required: json["required"],
        endDate: DateTime.parse(json["end_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "discount": discount,
        "required":required,
        "end_date": endDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
