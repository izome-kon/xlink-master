import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Models/resturant_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';

class OrdersPageModel {
  OrdersPageModel({
    this.orders,
    this.count,
  });

  List<Order> orders;
  int count;

  factory OrdersPageModel.fromJson(Map<String, dynamic> json) =>
      OrdersPageModel(
        orders: List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
        count: json["count"],
      );
}

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
  int deliveryId;
  dynamic discount;
  String comment;
  dynamic checkDelivery;
  DateTime createdAt;
  DateTime updatedAt;
  List<Product> product;
  
  Resturant resturant;

  setPromo(dynamic dis) {
    this.discount = dis;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    //userFromJson
    Resturant r = Resturant.fromJson(json["resturant"]);
    r.userFromJson(json["resturant"]['user']);
    return Order(
      id: json["id"],
      resturantId: json["resturant_id"],
      subtotal: json["subtotal"].toDouble(),
      total: json["total"].toDouble(),
      deliveryCost: json["delivery_cost"],
      deliveryId: json["delivery_id"] == null ? null : json["delivery_id"],
      discount: json["discount"],
      comment: json["comment"] == null ? null : json["comment"],
      checkDelivery: json["check_delivery"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      product:
          List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
      resturant: r,
    );
  }
  factory Order.fromJsonForWholesaler(Map<String, dynamic> json) {
    List<Product> products = [];
    dynamic subtotal = 0;
    for (var x in json["product"]) {
      // print(x);
      if (json["pivot"]['wholesaler_id'] == x['pivot']['wholesaler_id']) {
        Product pro = Product.fromJson(x);
        subtotal += pro.pivot.cost * pro.pivot.quantity;
        products.add(pro);
      }
    }
    return Order(
      id: json["id"],
      resturantId: json["resturant_id"],
      subtotal: subtotal.toDouble(),
      total: (subtotal + json["delivery_cost"]).toDouble(),
      deliveryCost: json["delivery_cost"],
      deliveryId: json["delivery_id"] == null ? null : json["delivery_id"],
      discount: json["discount"],
      comment: json["comment"] == null ? null : json["comment"],
      checkDelivery: json["check_delivery"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      product: products,
      resturant: json["resturant"] != null
          ? Resturant.fromJson(json["resturant"])
          : null,
    );
  }
}

class ProductPivot {
  ProductPivot({
    this.orderId,
    this.productId,
    this.quantity,
    this.cost,
    this.wholesalerId,
  });

  int orderId;
  int productId;
  int quantity;
  dynamic cost;
  dynamic wholesalerId;

  factory ProductPivot.fromJson(Map<String, dynamic> json) => ProductPivot(
        orderId: json["order_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        cost: json["cost"].toDouble(),
        wholesalerId: json["wholesaler_id"] is int
            ? json["wholesaler_id"]
            : json["wholesaler_id"] == null
                ? null
                : Wholesaler.fromJson(json["wholesaler_id"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_id": productId,
        "quantity": quantity,
        "cost": cost,
        "wholesaler_id": wholesalerId == null ? null : wholesalerId.toJson(),
      };
}

class WholesalerIdPivot {
  WholesalerIdPivot({
    this.productId,
    this.wholesalerId,
    this.cost,
  });

  int productId;
  int wholesalerId;
  double cost;

  factory WholesalerIdPivot.fromJson(Map<String, dynamic> json) =>
      WholesalerIdPivot(
        productId: json["product_id"],
        wholesalerId: json["wholesaler_id"],
        cost: json["cost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "wholesaler_id": wholesalerId,
        "cost": cost,
      };
}
