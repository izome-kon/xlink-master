import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Shared/chat.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:beda3a/Widgets/wholesaler_product_card.dart';

import 'package:beda3a/utils/images.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WholesalerSearchPage extends StatefulWidget {
  final String text;
  WholesalerSearchPage(this.text);
  @override
  _ResturantSearchPageState createState() => _ResturantSearchPageState();
}

class _ResturantSearchPageState extends State<WholesalerSearchPage> {
  List<Product> productList;
  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    GlobalProvider prov = Provider.of<GlobalProvider>(context, listen: false);
    await ApiHelper()
        .fetchWholesalerSearch(prov.user.wholesaler.id, widget.text)
        .then((value) {
      productList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ? Center(child: CircularProgressIndicator())
            : productList.length != 0
                ? ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return WholesalerProductCard(productList[index]);
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          "لم تجد منتجك وبحاجة للمساعدة ؟",
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
                                onPressed: Chat.startChat,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
