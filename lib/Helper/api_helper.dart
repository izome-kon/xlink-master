import 'dart:convert';
import 'dart:io';

import 'package:beda3a/Models/category_model.dart';
import 'package:beda3a/Models/category_page_model.dart';
import 'package:beda3a/Models/delivey_model.dart';
import 'package:beda3a/Models/location_model.dart';
import 'package:beda3a/Models/notification_model.dart';
import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Models/promocode_model.dart';
import 'package:beda3a/Models/resturant_model.dart';
import 'package:beda3a/Models/user_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:dio/dio.dart';

enum UserUpdateStates { DONE, PHONE_ERROR }

class ApiHelper {
  static final ApiHelper _singleton = ApiHelper._internal();
  GlobalProvider globalProvider;
  //TODO:: change this link
  final String apiUrl = "https://xlink.ideagroup-sa.com/api";
  Dio _dio;
  Response _response;
  factory ApiHelper() {
    return _singleton;
  }

  ApiHelper._internal() {
    _dio = Dio();
  }
  get response => _response;

  Future<String> login(
      {int phoneNumber, String password, String deviceToken}) async {
    try {
      Response _response = await _dio.post("$apiUrl/user/login", data: {
        "phone": "$phoneNumber",
        "password": "$password",
        "device_token": "$deviceToken"
      });
      await fetchUser(_response.data['token']);
      SharedPref.setToken(_response.data['token']);
      print(_response.data);
      print(SharedPref.getToken());
      return null;
    } on DioError catch (_) {
      return 'يرجى التأكد من رقم الهاتف وكلمة المرور';
    }
  }

  Future<String> signUp(
      name, phone, password, resturantName, locationId) async {
    var dio = Dio();
    await dio.post("$apiUrl/user/resturant/create", data: {
      "name": name,
      "phone": phone,
      "password": password,
      "resturantname": resturantName,
      "location_id": locationId,
      "device_token": "${SharedPref.deviceToken}",
      "role_id": 3
    }).then((value) {
      SharedPref.setToken(value.data[0]['token']);
      fetchUser(value.data[0]['token']);
    });

    return null;
  }

  Future<void> fetchUser(String token) async {
    _response = await _dio.get('$apiUrl/me',
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        }));
    // print(_response.data);
  }

  List<Product> paseProduct(response) {
    final parsed = response.cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  List<CategoryPageModel> paseCategoryPage(response) {
    final parsed = response.cast<Map<String, dynamic>>();

    return parsed
        .map<CategoryPageModel>((json) => CategoryPageModel.fromJson(json))
        .toList();
  }

  List<Category> paseCategory(response) {
    final parsed = response.cast<Map<String, dynamic>>();

    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }

  User paseUser(Map<String, dynamic> response) {
    if (response['resturant'] != null) {
      print(response);
      Resturant resturant = Resturant.fromJson(response['resturant']);
      resturant.userFromJson(response);
      return resturant;
    } else if (response['wholesaler'] != null) {
      Wholesaler wholesaler = Wholesaler.fromJson(response['wholesaler']);
      wholesaler.userFromJson(response);
      return wholesaler;
    } else if (response['delivery'] != null) {
      Delivery delivery = Delivery.fromJson(response['delivery']);
      delivery.userFromJson(response);
      return delivery;
    }
    return null;
  }

  Future readNotifcations(int tokenID) async {
    await _dio.get("$apiUrl/readNotifcation?token_id=$tokenID");
  }

  Future<NotificationBloc> fetchNotifcations(int id) async {
    var dio = Dio();
    Response response = await dio.get(
      '$apiUrl/notification?id=$id',
    );
    return NotificationBloc.fromJson(response.data);
  }

  Future<List<Product>> fetchSearchProducts(String text) async {
    _response = await _dio.get('$apiUrl/resturant/search?search=$text');

    return paseProduct(_response.data);
  }

  Future<List<CategoryPageModel>> ferchCategoryPage(int id) async {
    _response = await _dio.get('$apiUrl/getcategory?id=$id');

    return paseCategoryPage(_response.data);
  }

  Future<OrdersPageModel> fetchOrders(int id) async {
    var dio = Dio();
    Response response =
        await dio.post("$apiUrl/resturant/order", data: {"id": "$id"});
    // print(response.data['data']);
    return OrdersPageModel.fromJson(response.data);
  }

  Future<Promocode> fetchPromoCode(String code) async {
    var dio = Dio();
    Response response =
        await dio.post("$apiUrl/promocode/show", data: {"code": "$code"});

    return Promocode.fromJson(response.data);
  }

  Future<int> fetchPlaceOrder({Order order}) async {
    String products = order.product[0].id.toString();
    String quantitys = order.product[0].pivot.quantity.toString();
    String cost = order.product[0].pivot.cost.toString();
    for (int i = 1; i < order.product.length; i++) {
      products += " " + order.product[i].id.toString();
      quantitys += " " + order.product[i].pivot.quantity.toString();
      cost += " " + order.product[i].pivot.cost.toString();
    }

    var dio = Dio();
    Response response;
    try {
      response = await dio.post("$apiUrl/order", data: {
        "resturant_id": order.resturantId,
        "subtotal": order.subtotal,
        "total": order.total,
        "delivery_cost": order.deliveryCost,
        "discount": order.discount == null ? 0 : order.discount,
        "product_id": "$products",
        "quantity": "$quantitys",
        "cost": "$cost",
        "comment": "${order.comment}"
      });
    } on DioError catch (_) {
      throw Exception();
    }
    // print(response.data);
    return response.data['id'];
  }

  Future<String> uploadImage(
      File image, String pathOnServer, int userID) async {
    String url = "$apiUrl/uploadImage";
    String type = image.path.split('.').last;
    var dio = Dio();
    Response response = await dio.post(url, data: {
      "image": base64Encode(image.readAsBytesSync()),
      "type": type,
      "pathOnServer": pathOnServer,
      "user_id": userID
    });
    // print(userID);
    // print(response.data);
    return response.data;
  }

  Future<UserUpdateStates> updateUser(User user) async {
    var dio = Dio();
    try {
      user.roleId == 3
          ? await dio.post("$apiUrl/user/update", data: {
              "id": user.userId,
              "phone": user.phone,
              "roleId": user.roleId,
              "name": user.userName,
              "resturant_name": user.resturant.name
            })
          : await dio.post("$apiUrl/user/update", data: {
              "id": user.userId,
              "phone": user.phone,
              "roleId": user.roleId,
              "name": user.userName,
              "resturant_name": ""
            });
      return UserUpdateStates.DONE;
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) return UserUpdateStates.PHONE_ERROR;
    }
    // print(response.data);
  }

  Future<Response> changePassword(
      String curPassword, String newPassword, int id) async {
    var dio = Dio();

    Response response = await dio.get(
        '$apiUrl/resetpassword?newPassword=$newPassword&password=$curPassword&user_id=$id');
    //print(response.data);
    return response;
  }

  Future<List<Location>> allLocations() async {
    var dio = Dio();
    Response response = await dio.get("$apiUrl/AllLocations");
    return locations(response.data);
  }

  List<Location> locations(response) {
    // print(response);
    final parsed = response.cast<Map<String, dynamic>>();
    return parsed.map<Location>((json) => Location.fromJson(json)).toList();
  }

  Future<void> fetchUpdate(
      int wholesalerId, int productId, int available) async {
    var dio = Dio();
    await dio.post("$apiUrl/update/availability", data: {
      "wholesaler_id": wholesalerId,
      "product_id": productId,
      "available": available
    });
  }

  Future<void> updateProductCost(
      int wholesalerId, int productId, dynamic cost) async {
    var dio = Dio();
    try {
      await dio.post("$apiUrl/update/cost", data: {
        "wholesaler_id": wholesalerId,
        "product_id": productId,
        "cost": cost
      });
    } on DioError catch (e) {
      // print({"state": e.response.statusCode, "error data": e.response.data});
    }
  }

  Future<List<Product>> fetchWholesalerSearch(int id, String text) async {
    var dio = Dio();
    Response response =
        await dio.get("$apiUrl/wholesaler/search?id=$id&text=$text");

    return paseProducts(jsonEncode(response.data));
  }

  List<Product> paseProducts(response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  Future<List<Order>> fetchWholeslaerOrders(int id) async {
    var dio = Dio();
    Response response =
        await dio.post("$apiUrl/wholesaler/order", data: {"wholesaler_id": id});
    // print(response.data);
    return paseWholesalerOrders(response.data);
  }

  List<Order> paseWholesalerOrders(response) {
    final parsed = response.cast<Map<String, dynamic>>();
    return parsed.map<Order>((json) {
      return Order.fromJsonForWholesaler(json);
    }).toList();
  }

  Future<List<Order>> fetchDeliveryOrders(int id) async {
    var dio = Dio();
    Response response = await dio.post("$apiUrl/delivery/order?id=$id");
    // print(response.data);
    return paseDeliveryOrders(response.data['order']);
  }

  List<Order> paseDeliveryOrders(response) {
    final parsed = response.cast<Map<String, dynamic>>();
    return parsed.map<Order>((json) {
      return Order.fromJson(json);
    }).toList();
  }

  Future<void> submitDeliveryOrder(
      int orderID, userID, reqCost, paidCost) async {
    var dio = Dio();

    await dio.post("$apiUrl/delivery/submit?order_ID=$orderID");
    await dio.post("$apiUrl/wallet/update",
        data: {"user_id": userID, "required": reqCost, "paid_up": paidCost});
  }

  Future walletUpdate(userID, reqCost, paidCost) async {
    var dio = Dio();
    await dio.post("$apiUrl/wallet/update",
        data: {"user_id": userID, "required": reqCost, "paid_up": paidCost});
  }

  addProduct(int id, String name, String des, String cost, File image,
      String pathOnServer) async {
    var dio = Dio();

    if (image != null) {
      String type = image.path.split('.').last;
      await dio.post("$apiUrl/new/product", data: {
        "id": id,
        "type": type,
        "name": name,
        "description": des,
        "cost": cost,
        "image": base64Encode(image.readAsBytesSync()),
        "pathOnServer": pathOnServer,
      });
    } else
      await dio.post("$apiUrl/new/product", data: {
        "id": id,
        "name": name,
        "description": des,
        "cost": cost,
        "pathOnServer": pathOnServer,
      });
  }
}
