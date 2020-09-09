import 'package:beda3a/Models/delivey_model.dart';
import 'package:beda3a/Models/resturant_model.dart';
import 'package:beda3a/Models/wallet_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';

abstract class User {
  User({
    this.userId,
    this.roleId,
    this.userName,
    this.avatar,
    this.phone,
    this.phoneVerifiedAt,
    this.settings,
    this.active,
    this.onlineCounter,
    this.createdAt,
    this.updatedAt,
    this.wallet,
  });

  int userId;
  int roleId;
  String userName;
  String avatar;
  int phone;
  dynamic phoneVerifiedAt;
  List<dynamic> settings;
  int active;
  int onlineCounter;
  DateTime createdAt;
  DateTime updatedAt;
  Resturant resturant;
  Delivery delivery;
  Wholesaler wholesaler;
  Wallet wallet;

  Map<String, dynamic> userToJson() {
    return {
      'id': userId,
      'role_id': roleId,
      'name': userName,
      'avatar': avatar,
      'phone': phone,
      'phone_verified_at':
          phoneVerifiedAt != null ? phoneVerifiedAt.toIso8601String() : null,
      'active': active,
      'online_counter': onlineCounter,
      'created_at': createdAt != null ? createdAt.toIso8601String() : null,
      'updated_at': updatedAt != null ? updatedAt.toIso8601String() : null,
      'resturant': resturant != null ? resturant.toJson() : null,
      'delivery': delivery != null ? delivery.toJson() : null,
      'wholesaler': wholesaler != null ? wholesaler.toJson() : null,
      'wallet': wallet != null ? wallet.toJson() : null,
    };
  }
}
