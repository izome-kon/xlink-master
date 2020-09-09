import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Widgets/delivary_order_card.dart';
import 'package:beda3a/Widgets/message.dart';
import 'package:beda3a/Widgets/order_card.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/order_card.dart';

class DeliveryOrders extends StatefulWidget {
  @override
  _DeliveryOrdersState createState() => _DeliveryOrdersState();
}

class _DeliveryOrdersState extends State<DeliveryOrders> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _index;

  bool empty = false;

  @override
  void initState() {
    _index = _pageController.initialPage;

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
              child: Text('عرض كمطاعم',
                  style: TextStyle(fontFamily: arabicFontMedium)),
            ),
            Tab(
              child: Text('عرض كتجار',
                  style: TextStyle(fontFamily: arabicFontMedium)),
            )
          ]),
          centerTitle: true,
        ),
        body: Consumer<GlobalProvider>(
          builder: (context, prov, child) {
            return TabBarView(physics: BouncingScrollPhysics(), children: [
              FutureBuilder<List<Order>>(
                  future:
                      ApiHelper().fetchDeliveryOrders(prov.user.delivery.id),
                  builder: (BuildContext context, snapshot) {
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
                            message: ' لا يوجد لديك طلبات حالياً',
                          );
                        else
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: oldOrders.length,
                              itemBuilder: (context, index) {
                                return OrderCard(
                                  orderCardType: OrderCardType.DELIVERY,
                                  orderPage: oldOrders[index],
                                );
                              });
                      } else {
                        return Message(
                          image: 'assets/images/box.png',
                          message: ' لا يوجد لديك طلبات حالياً',
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              FutureBuilder<List<Order>>(
                  future:
                      ApiHelper().fetchDeliveryOrders(prov.user.delivery.id),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<Wholesaler, List<Product>> _cardsData = {};

                      for (Order order in snapshot.data) {
                        int wholesalerID;
                        for (Product pro in order.product) {
                          wholesalerID = pro.pivot.wholesalerId;
                          for (Wholesaler wholesaler in pro.wholesaler) {
                            if (wholesaler.id == wholesalerID) {
                              bool foundWhole = false;
                              int j;
                              for (j = 0; j < _cardsData.entries.length; j++) {
                                if (wholesaler.id ==
                                    _cardsData.entries.elementAt(j).key.id) {
                                  foundWhole = true;
                                  break;
                                }
                              }
                              if (foundWhole) {
                                bool foundPro = false;
                                for (int i = 0;
                                    i <
                                        _cardsData.entries
                                            .elementAt(j)
                                            .value
                                            .length;
                                    i++) {
                                  if (_cardsData.entries
                                          .elementAt(j)
                                          .value[i]
                                          .id ==
                                      pro.id) {
                                    _cardsData.entries
                                        .elementAt(j)
                                        .value[i]
                                        .pivot
                                        .quantity += pro.pivot.quantity;
                                    foundPro = true;
                                    break;
                                  }
                                }
                                if (!foundPro) {
                                  _cardsData.entries
                                      .elementAt(j)
                                      .value
                                      .add(pro);
                                }
                              } else {
                                pro.pivot.quantity = 1;
                                _cardsData[wholesaler] = [pro];
                              }
                              break;
                            }
                          }
                        }
                      }
                      return _cardsData.length == 0
                          ? Message(
                              image: 'assets/images/box.png',
                              message: ' لا يوجد لديك طلبات حالياً',
                            )
                          : ListView.builder(
                              itemCount: _cardsData.length,
                              itemBuilder: (context, index) {
                                GlobalKey<ExpansionTileCardState> card =
                                    new GlobalKey();
                                return DeliveryOrderCard(
                                  card: card,
                                  wholesaler:
                                      _cardsData.entries.elementAt(index).key,
                                  products:
                                      _cardsData.entries.elementAt(index).value,
                                );
                              },
                            );

                      // if (snapshot.hasData) {
                      //   List<Order> oldOrders = [];
                      //   for (Order order in snapshot.data) {
                      //     if (order.checkDelivery != null) {
                      //       oldOrders.add(order);
                      //     }
                      //   }
                      //   if (oldOrders.length == 0)
                      //     return Message(
                      //       image: 'assets/images/box.png',
                      //       message: 'لا يوجد لديك طلبات',
                      //     );
                      //   else
                      // return ListView.builder(
                      //     itemCount: oldOrders.length,
                      //     physics: BouncingScrollPhysics(),
                      //     itemBuilder: (context, index) {

                      // } else {
                      //   return Message(
                      //     image: 'assets/images/box.png',
                      //     message: 'لا يوجد لديك طلبات',
                      //   );
                      // }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ]);
          },
        ),
      ),
    );
  }
}
