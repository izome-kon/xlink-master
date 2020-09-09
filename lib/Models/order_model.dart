import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Models/resturant_model.dart';

class Order {
  Order({
    this.id,
    this.resturantId,
    this.subtotal,
    this.total,
    this.deliveryCost,
    this.deliveryId,
    this.discount,
    this.comment,
    this.checkDelivery,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.resturant,
  });

  int id;
  int resturantId;
  dynamic subtotal;
  dynamic total;
  dynamic deliveryCost;
  dynamic deliveryId;
  dynamic discount;
  dynamic comment;
  dynamic checkDelivery;
  DateTime createdAt;
  DateTime updatedAt;
  List<Product> product;
  Resturant resturant;
  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        resturantId: json["resturant_id"],
        subtotal: json["subtotal"],
        total: json["total"],
        deliveryCost: json["delivery_cost"],
        deliveryId: json["delivery_id"],
        discount: json["discount"],
        comment: json["comment"],
        checkDelivery: json["check_delivery"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product:
            List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
        resturant: Resturant.fromJson(json["resturant"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "resturant_id": resturantId,
        "subtotal": subtotal,
        "total": total,
        "delivery_cost": deliveryCost,
        "delivery_id": deliveryId,
        "discount": discount,
        "comment": comment,
        "check_delivery": checkDelivery,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
