import 'dart:convert';

import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';

class Product {
  Product(
      {this.id,
      this.name,
      this.image,
      this.size,
      this.expirationDate,
      this.categoryId,
      this.createdAt,
      this.updatedAt,
      this.pivot,
      this.wholesaler,
      this.description,
      this.cost,
      this.confirmed,
      this.available});

  int id;
  String name;
  String description;
  List<String> image;
  String size;
  dynamic expirationDate;
  int categoryId;
  int available;
  int confirmed;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic cost;
  ProductPivot pivot;
  List<Wholesaler> wholesaler;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        image: json["image"].split(','),
        size: json["size"],
        confirmed: json['confirmed'],
        expirationDate: json["expiration_date"],
        description: json["description"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        cost: json["cost"],
        available: json['available'],
        pivot:
            json["pivot"] == null ? null : ProductPivot.fromJson(json["pivot"]),
        wholesaler: json["wholesaler"] == null
            ? null
            : List<Wholesaler>.from(json["wholesaler"].map((x) {
                Wholesaler whole = Wholesaler.fromJson(x);
                whole.userFromJson(x['user']);
                return whole;
              })),
      );

  Map<String, dynamic> toJson() {
    String images = '';
    for (String s in image) {
      images += s + ',';
    }
    return {
      "id": id,
      "name": name,
      "image": images,
      "size": size,
      "expiration_date": expirationDate,
      "category_id": categoryId,
      "created_at": createdAt,
      "updated_at": updatedAt,
      'cost': cost,
      'pivot': pivot == null ? null : pivot.toJson(),
      'wholesaler': wholesaler == null
          ? null
          : List<Wholesaler>.from(wholesaler.map((x) {
              var whole = x.toJson();
              return whole;
            })),
    };
  }
}
