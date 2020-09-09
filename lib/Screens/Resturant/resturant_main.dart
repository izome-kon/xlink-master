import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:badges/badges.dart';
import 'package:beda3a/Models/offer_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Basics/pop_up.dart';
import 'package:beda3a/Screens/Resturant/resturant_cart.dart';
import 'package:beda3a/Screens/Resturant/resturant_home.dart';
import 'package:beda3a/Screens/Basics/connect_us.dart';
import 'package:beda3a/Screens/Basics/Profile/profile.dart';
import 'package:beda3a/Screens/Resturant/resturant_orders_page.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:beda3a/utils/theme.dart';

import 'package:flutter/material.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:provider/provider.dart';

class ResturantMain extends StatefulWidget {
  @override
  _ResturantMainState createState() => _ResturantMainState();
}

class _ResturantMainState extends State<ResturantMain> {
  final PageController _pageController = PageController();
  int pageIndex = 0;
  GlobalKey mainKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, prov, child) {
      return Scaffold(

          //appBar: ,
          extendBody: true,
          body: PageView(
            key: mainKey,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              ResturantHome(),
              ResturantOrdersPage(),
              ConnectUs(),
              Profile(),
            ],
          ),
          floatingActionButton: prov.getProducts.length == 0
              ? null
              : Badge(
                  animationType: BadgeAnimationType.scale,
                  elevation: 1,
                  shape: BadgeShape.square,
                  borderRadius: 10,
                  badgeContent: Text(
                    '${prov.getProducts.length}',
                    style: TextStyle(color: whiteColor),
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ResturantCart()));
                    },
                    elevation: 2,
                    backgroundColor: primaryColor,
                    child: AvatarGlow(
                      glowColor: whiteColor,
                      endRadius: 50.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: Icon(Icons.shopping_cart),
                    ),
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar:
              Consumer<CartProvider>(builder: (context, prov, child) {
            return BottomAppBar(
                notchMargin: 8,
                color: Colors.grey[200],
                elevation: 10,
                shape: CircularNotchedRectangle(),
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.home,
                                color: pageIndex == 0
                                    ? accentColor
                                    : Colors.black38,
                              ),
                              Text(
                                'الرئيسية',
                                style: pageIndex == 0
                                    ? TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold)
                                    : TextStyle(
                                        color: Colors.black38,
                                      ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          _pageController.jumpToPage(0);
                          setState(() {
                            pageIndex = 0;
                          });
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.assignment,
                                color: pageIndex == 1
                                    ? accentColor
                                    : Colors.black38,
                              ),
                              Text(
                                'طلباتي',
                                style: pageIndex == 1
                                    ? TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold)
                                    : TextStyle(
                                        color: Colors.black38,
                                      ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          _pageController.jumpToPage(1);
                          setState(() {
                            pageIndex = 1;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: Container(
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.message,
                                color: pageIndex == 2
                                    ? accentColor
                                    : Colors.black38,
                              ),
                              Text(
                                'تواصل معنا',
                                style: pageIndex == 2
                                    ? TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold)
                                    : TextStyle(
                                        color: Colors.black38,
                                      ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          _pageController.jumpToPage(2);
                          setState(() {
                            pageIndex = 2;
                          });
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                color: pageIndex == 3
                                    ? accentColor
                                    : Colors.black38,
                              ),
                              Text(
                                'بياناتي',
                                style: pageIndex == 3
                                    ? TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold)
                                    : TextStyle(
                                        color: Colors.black38,
                                      ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          _pageController.jumpToPage(3);
                          setState(() {
                            pageIndex = 3;
                          });
                        },
                      ),
                    ],
                  ),
                ));
          }));
    });
  }
}
