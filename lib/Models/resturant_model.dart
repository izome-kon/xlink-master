import 'package:beda3a/Models/location_model.dart';
import 'package:beda3a/Models/offer_model.dart';
import 'package:beda3a/Models/user_model.dart';
import 'package:beda3a/Models/wallet_model.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:provider/provider.dart';

class Resturant extends User {
  Resturant(
      {this.id,
      this.name,
      this.locationId,
      this.segmentation,
      this.createdAt,
      this.updatedAt,
      this.listOfPromo,
      this.userId,
      this.location,
      this.offers,
        this.popUpoffers});

  int id;
  String name;
  int locationId;
  String segmentation;
  DateTime createdAt;
  DateTime updatedAt;
  String listOfPromo;
  Location location;
  int userId;
  List<Offer> offers;
  Offer popUpoffers;
  factory Resturant.fromJson(Map<String, dynamic> json) {
    List<Offer> offers =[];
    Offer popUpoffers =null;
    for(int i = 0 ; i < json["offer"].length;i++){
      Offer of = Offer.fromJson(json['offer'][i]);
      if(of.popUp==1){
        popUpoffers = of;
      }else{
        offers.add(of);
      }
    }
    return Resturant(
      id: json["id"],
      name: json["name"],
      locationId: json["location_id"],
      segmentation: json["segmentation"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      listOfPromo: json["list_of_promo"],
      userId: json["user_id"],
      offers: offers,
      popUpoffers:popUpoffers,
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location_id": locationId,
        "segmentation": segmentation,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "list_of_promo": listOfPromo,
        "user_id": userId,
        "location": location.toJson(),
        "offer": List<Offer>.from(offers.map((x) => x.toJson())),
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
    super.wallet = Wallet.fromJson(json['wallet']);
    super.resturant = this;
  }
}
