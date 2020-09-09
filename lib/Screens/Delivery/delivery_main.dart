import 'package:beda3a/Screens/Basics/Profile/profile.dart';
import 'package:beda3a/Screens/Basics/connect_us.dart';
import 'package:beda3a/Screens/Delivery/delivary_orders_page.dart';
import 'package:flutter/material.dart';

import 'package:beda3a/utils/theme.dart';

class DeliveryMain extends StatefulWidget {
  get showAsBottomSheet => null;

  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryMain> {
  PageController _pageController;
  int _pageIndex;

  @override
  void initState() {
    _pageController = new PageController();
    _pageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: <Widget>[
          DeliveryOrders(),
          ConnectUs(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          selectedItemColor: accentColor,
          unselectedItemColor: primaryColor,
          onTap: (index) {
            setState(() {
              _pageController.jumpToPage(index);
              _pageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("قائمة الطلبات")),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), title: Text("تواصل معنا")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("الملف الشخصي")),
          ]),
    );
  }
}
