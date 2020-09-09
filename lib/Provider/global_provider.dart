import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/category_model.dart';
import 'package:beda3a/Models/delivey_model.dart';
import 'package:beda3a/Models/notification_model.dart';
import 'package:beda3a/Models/offer_model.dart';
import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Models/resturant_model.dart';
import 'package:beda3a/Models/user_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class GlobalProvider extends ChangeNotifier {
  User _user;
  User oldUser;
  List<Product> _products = [];
  List<Category> _categories = [];
  NotificationBloc _notifications = NotificationBloc();
  OrdersPageModel _ordersPageModel;
  List<Offer> popUpOffers = [];
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  String usersImageProflilUrl = "https://xlink.ideagroup-sa.com/storage";

  setUser(User user) {
    this._user = user;

    notifyListeners();
  }

  setUserImage(value) {
    _user.avatar = value;
    notifyListeners();
  }

  setOrdersPageModel(OrdersPageModel ordersPageModel) {
    this._ordersPageModel = ordersPageModel;
    notifyListeners();
  }

  setProducts(List<Product> products) {
    this._products = products;

    notifyListeners();
  }

  setNotification(NotificationBloc notifications) {
    this._notifications = notifications;
    notifyListeners();
  }

  setCategories(List<Category> categories) {
    this._categories = categories;
    notifyListeners();
  }

  User get user => _user;
  NotificationBloc get notifications => _notifications;
  Future<void> userRefresh() async {

    await ApiHelper().fetchUser(SharedPref.getToken()).then((_) async {
      await Jiffy.locale('ar');
      if (user is Resturant) {
        setProducts(
            ApiHelper().paseProduct(ApiHelper().response.data['products']));
        setCategories(
            ApiHelper().paseCategory(ApiHelper().response.data['categories']));
        setUser(ApiHelper().paseUser(ApiHelper().response.data['user']));
        NotificationBloc notificationBloc =
            await ApiHelper().fetchNotifcations(user.userId);

        setNotification(notificationBloc);
        for (int i = 0; i < user.resturant.offers.length; i++) {
          for (int j = 0; j < products.length; j++) {
            if (user.resturant.offers[i].product.id == products[j].id) {
              products[j].cost = user.resturant.offers[i].product.cost;
              break;
            }
          }
        }
      } else if (user is Wholesaler) {
        print(ApiHelper().response.data['products']['original']);
        setProducts(ApiHelper()
            .paseProduct(ApiHelper().response.data['products']['original']));
      } else if (user is Delivery) {}
      //SharedPref.showOpenDialog(scaffoldkey.currentContext);
      notifyListeners();
    });
  }

  List<Category> get categories => _categories;
  List<Product> get products => _products;

  int unReadNotifications() {
    int count = 0;
    if (_notifications.notifcation != null)
      for (Notifcation not in _notifications.notifcation) {
        if (not.pivot.isRead == 0) {
          count++;
        }
      }
    return count;
  }

  readNotifications() {
    for (Notifcation not in _notifications.notifcation) {
      if (not.pivot.isRead == 0) {
        not.pivot.isRead = 1;
      }
    }
    notifyListeners();
  }

  Product foundProduct(Product prod) {
    for (Product pro in _products) {
      if (pro.id == prod.id) return pro;
    }
    return null;
  }

  updateProduct(Product prod) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == prod.id) {
        _products[i] = prod;
        notifyListeners();
        return true;
      }
    }
    return null;
  }
}
