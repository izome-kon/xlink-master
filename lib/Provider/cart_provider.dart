import 'dart:convert';

import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:flutter/widgets.dart';

enum SendOrderState { WAITING, ORDERING, ERROR, SUCCEES }

class CartProvider extends ChangeNotifier {
  List<List<Product>> _products = [];
  Order newOrder;
  TextEditingController commentController = TextEditingController();
  SendOrderState orderingState = SendOrderState.WAITING;
  CartProvider({List<List<Product>> products});

  emptyCart() {
    _products = [];
    commentController = TextEditingController();
    orderingState = SendOrderState.WAITING;
    SharedPref.emptyCart();
    notifyListeners();
  }

  updateCart(List<Product> products){
    for(int j = 0 ; j < _products.length;j++){
      bool found = false;
      for(int i = 0 ; i < products.length;i++)
      if(products[i].id == _products[j][0].id){
        found = true;
        if(_products[j][0].cost!=products[i].cost)
          for(int k = 0 ; k < _products[j].length;k++){
            _products[j][k].cost = products[i].cost;
          }
      }
      if(!found)
        _products.removeAt(j);
    }
    notifyListeners();
  }

  List<List<Product>> cartFromJson(String str) {
    print('cart=>>>>>>>>>'+str);
    _products =
    List<List<Product>>.from(json.decode(str).map((x) => List<Product>.from(x.map((x) => Product.fromJson(x)))));
    notifyListeners();
  }

  String cartToJson() => json.encode(List<dynamic>.from(_products.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))));


  addProduct(Product pro) {
    bool found = false;
    for (int i = 0; i < _products.length; i++) {
      if (pro.id == _products[i][0].id) {
        _products[i].add(pro);
        found = true;
      }
    }
    if (!found) _products.add([pro]);
    // print(_products.length);
    //SharedPref.setCart(cartToJson());
    notifyListeners();
  }

  editComment(String text) {
    commentController = TextEditingController(text: text);
    notifyListeners();
  }

  removeProduct(Product pro, {bool fource: false}) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i][0].id == pro.id) {
        if (_products[i].length == 1) if (fource) {
          _products.removeAt(i);
          notifyListeners();
        } else {
          return -1;
        }
        else {
          _products[i].removeAt(0);
        }
        break;
      }
    }
    SharedPref.setCart(cartToJson());
    notifyListeners();
  }

  removeProductByIndex(int i) {
    if (_products[i].length == 1)
      _products.removeAt(i);
    else {
      _products[i].removeAt(0);
    }
    SharedPref.setCart(cartToJson());
    notifyListeners();
  }

  removeAllProductByIndex(int i) {
    _products.removeAt(i);
    SharedPref.setCart(cartToJson());
    notifyListeners();
  }

  Future<void> ordering() async {
    orderingState = SendOrderState.ORDERING;

    try {
      await ApiHelper().fetchPlaceOrder(order: newOrder).then((value) {
        orderingState = SendOrderState.SUCCEES;
      });
    } catch (e) {
      orderingState = SendOrderState.ERROR;
    }
  }

  setOrderFormat(dynamic deliveryCost, int resturantID) {
    List<Product> products = [];
    dynamic subTotal = 0;

    for (int i = 0; i < _products.length; i++) {
      Product curPro = _products[i][0];
      curPro.pivot = ProductPivot();
      curPro.pivot.cost = _products[i][0].cost;
      curPro.pivot.quantity = _products[i].length;
      subTotal += curPro.pivot.cost * curPro.pivot.quantity;
      products.add(curPro);
    }

    newOrder = Order(
        createdAt: DateTime.now(),
        comment:
            commentController.text.length == 0 ? null : commentController.text,
        deliveryCost: deliveryCost,
        product: products,
        subtotal: subTotal,
        total: (subTotal + deliveryCost),
        resturantId: resturantID);
  }

  dynamic orderDisCount;
  setPromoCode(dynamic dis, dynamic deliveryCost) {
    newOrder.discount = dis;
    newOrder.total -= dis;
    notifyListeners();
  }

  List<Product> foundProduct(Product pro) {
    for (int i = 0; i < _products.length; i++) {
      if (pro.id == _products[i][0].id) return _products[i];
    }
    return [];
  }

  List<List<Product>> get getProducts => _products;
}
