import 'package:beda3a/Models/product_model.dart';

class Offer {
  Offer(
      {this.id,
      this.image,
      this.productId,
      this.endDate,
      this.available,
        this.time,
      this.createdAt,
      this.updatedAt,
        this.popUp,
      this.product});

  int id;
  String image;
  int productId;
  DateTime endDate;
  int time;
  int available;
  int popUp;
  DateTime createdAt;
  DateTime updatedAt;

  Product product;

  factory Offer.fromJson(Map<String, dynamic> json) {
    Product pro = Product.fromJson(json["product"]);
    pro.cost = json["cost"];
    return Offer(
      id: json["id"],
      image: json["image"],
      productId: json["product_id"],
      endDate: DateTime.parse(json["end_date"]),
      available: json["available"],
      time: json["time"],
      popUp: json['pop_up'],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      product: pro,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "product_id": productId,
        "pop_up": popUp ,
         "time":time,
        "end_date": endDate.toIso8601String(),
        "available": available,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
