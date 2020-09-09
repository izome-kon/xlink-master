import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Screens/Resturant/resturant_order_info.dart';
import 'package:beda3a/utils/images.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../Screens/Resturant/resturant_order_info.dart';

enum OrderCardType { DELIVERY, NORMAL }

class OrderCard extends StatelessWidget {
  final Order orderPage;
  final OrderCardType orderCardType;
  const OrderCard(
      {Key key, this.orderPage, this.orderCardType: OrderCardType.NORMAL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Consumer<CartProvider>(builder: (context, prov, child) {
        return InkWell(
          onTap: () {
            prov.newOrder = orderPage;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        orderCardType == OrderCardType.DELIVERY
                            ? ResturantOrderInfo(
                                type: ResturantOrderInfoType.Delivery,
                              )
                            : ResturantOrderInfo()));
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Row(children: <Widget>[
                    order,
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(child: Text('#${orderPage.id}')),
                  ]),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                          child: Text(Jiffy(orderPage.createdAt).fromNow())),
                    ],
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Text(
                                "${orderPage.total.toStringAsFixed(1)} ج.م")),
                      ],
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
