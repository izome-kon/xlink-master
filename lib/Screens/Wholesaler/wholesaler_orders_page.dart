import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Widgets/message.dart';
import 'package:beda3a/Widgets/order_card.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WholesalerOrders extends StatefulWidget {
  @override
  _WholesalerOrdersState createState() => _WholesalerOrdersState();
}

class _WholesalerOrdersState extends State<WholesalerOrders> {
  List<String> ordersKeys = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'طلباتي',
              style: TextStyle(
                fontFamily: arabicFontMedium,
                color: whiteColor,
                fontSize: 20,
              ),
            ),
            bottom: TabBar(tabs: <Widget>[
              Tab(
                child: Text('تحت التنفيذ',
                    style: TextStyle(fontFamily: arabicFontMedium)),
              ),
              Tab(
                child: Text('مكتملة',
                    style: TextStyle(fontFamily: arabicFontMedium)),
              )
            ]),
            centerTitle: true,
          ),
          body: Consumer<GlobalProvider>(
            builder: (context, prov, child) {
              return TabBarView(physics: BouncingScrollPhysics(), children: [
                 FutureBuilder<List<Order>>(
                  future: ApiHelper()
                      .fetchWholeslaerOrders(prov.user.wholesaler.id),
                  builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<Order> oldOrders = [];
                        for (Order order in snapshot.data) {
                          if (order.checkDelivery == null) {
                            oldOrders.add(order);
                          }
                        }
                        if (oldOrders.length == 0)
                          return Message(
                            image: 'assets/images/box.png',
                            message: 'لا يوجد لديك طلبات',
                          );
                        else
                          return ListView.builder(
                              itemCount: oldOrders.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return OrderCard(
                                  orderPage: oldOrders[index],
                                );
                              });
                      } else {
                        return Message(
                          image: 'assets/images/box.png',
                          message: 'لا يوجد لديك طلبات',
                        );
                        
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                ),
                FutureBuilder<List<Order>>(
                  future: ApiHelper()
                      .fetchWholeslaerOrders(prov.user.wholesaler.id),
                  builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<Order> oldOrders = [];
                        for (Order order in snapshot.data) {
                          if (order.checkDelivery != null) {
                            oldOrders.add(order);
                          }
                        }
                        if (oldOrders.length == 0)
                          return Message(
                            image: 'assets/images/box.png',
                            message: 'لا يوجد لديك طلبات',
                          );
                        else
                          return ListView.builder(
                              itemCount: oldOrders.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return OrderCard(
                                  orderPage: oldOrders[index],
                                );
                              });
                      } else {
                        return Message(
                          image: 'assets/images/box.png',
                          message: 'لا يوجد لديك طلبات',
                        );
                        
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                ),
              ]);
            },
          )),
    );
  }
}
