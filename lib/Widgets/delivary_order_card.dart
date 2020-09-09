import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Widgets/item_card.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Shared/shared_pref.dart';
import '../Shared/shared_pref.dart';
import '../utils/theme.dart';
import '../utils/theme.dart';

class DeliveryOrderCard extends StatelessWidget {
  final Wholesaler wholesaler;
  final List<Product> products;
  final GlobalKey<ExpansionTileCardState> card;
  List<Widget> productsWidget;
  dynamic total = 0;
  DeliveryOrderCard({this.card, this.wholesaler, this.products}) {
    productsWidget = List.generate(products.length, (index) {
      total += (products[index].pivot.cost * products[index].pivot.quantity);
      return ItemCard(product: products[index]);
    });

    productsWidget.insert(
        0,
        Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Text('الاتصال بالتاجر',
                  style: TextStyle(fontFamily: arabicFontMedium, fontSize: 18)),
              Spacer(),
              CircleAvatar(
                backgroundColor: primaryColor,
                child: IconButton(
                    icon: Icon(Icons.phone),
                    color: Colors.white,
                    onPressed: () {
                     SharedPref.launchURL(wholesaler.phone.toString());
                    }),
              )
            ],
          ),
        ));
    productsWidget.insert(
        0,
        Divider(
          thickness: 1.0,
          height: 1.0,
        ));
    productsWidget.insert(
        productsWidget.length,
        Column(
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Text('المجموع الكلي ',
                      style: TextStyle(
                          fontFamily: arabicFontMedium, fontSize: 18)),
                  Spacer(),
                  Text('$total جنية',
                      style: TextStyle(
                          fontFamily: arabicFontMedium, fontSize: 18)),
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ExpansionTileCard(
          key: card,
          leading: Consumer<GlobalProvider>(
            builder: (context, prov, child) {
              return CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                    '${prov.usersImageProflilUrl}/${prov.user.avatar}',
                  ));
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${wholesaler.userName}'),
            ],
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: primaryColor.withOpacity(0.5),
              ),
              Text('${wholesaler.location}'),
            ],
          ),
          children: productsWidget,
        ),
      ),
    );
  }
}
