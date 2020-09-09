class Location {
  Location({
    this.id,
    this.address,
    this.deliveryCost,
  });

  int id;
  String address;
  dynamic deliveryCost;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        address: json["address"],
        deliveryCost: json["delivery_cost"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "delivery_cost": deliveryCost,
      };
}
