import 'package:avatar_glow/avatar_glow.dart';
import 'package:badges/badges.dart';
import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Shared/chat.dart';
import 'package:beda3a/Widgets/product_card.dart';
import 'package:beda3a/utils/images.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/cart_provider.dart';
import 'resturant_cart.dart';

class ResturantSearchPage extends StatefulWidget {
  final String text;
  ResturantSearchPage(this.text);
  @override
  _ResturantSearchPageState createState() => _ResturantSearchPageState();
}

class _ResturantSearchPageState extends State<ResturantSearchPage> {
  List<Product> productList;
  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    await ApiHelper().fetchSearchProducts(widget.text).then((value) {
      productList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, prov, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.text),
            backgroundColor: primaryColor,
          ),
          body: Container(
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: productList == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  )
                : productList.length != 0
                    ? ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductCard(productList[index]);
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("لا يوجد نتائج لهذا البحث!"),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 8, right: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      chat,
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "لم تجد بضاعتك وبحاجة للمساعدة ؟",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .apply(color: Colors.black),
                                            ),
                                            Text("تواصل معنا الآن!",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ActionChip(
                                    backgroundColor: primaryColor,
                                    label: Text(
                                      "المحادثة",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                    onPressed: //GlobalData.startChat
                                        () {
                                      Chat.startChat();
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
          ),
          floatingActionButton: prov.getProducts.length == 0
              ? null
              : AvatarGlow(
                  glowColor: primaryColor,
                  endRadius: 40.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Badge(
                    animationType: BadgeAnimationType.scale,
                    elevation: 1,
                    shape: BadgeShape.square,
                    borderRadius: 10,
                    badgeContent: Text(
                      '${prov.getProducts.length}',
                      style: TextStyle(color: whiteColor),
                    ),
                    child: FloatingActionButton(
                      elevation: 10,
                      tooltip: 'السلة',
                      backgroundColor: primaryColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResturantCart()));
                      },
                      child: Icon(Icons.shopping_cart),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
