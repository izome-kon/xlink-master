import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Resturant/resturant_order_info.dart';
import 'package:beda3a/Widgets/item_card.dart';
import 'package:beda3a/utils/sounds.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ResturantCart extends StatefulWidget {
  const ResturantCart({Key key}) : super(key: key);

  @override
  _ResturantCartState createState() => _ResturantCartState();
}

class _ResturantCartState extends State<ResturantCart> {
  ScrollController listviewController;

  var hight = 0.0;
  SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    listviewController = ScrollController();
  }

  @override
  void dispose() {
    listviewController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'سلة التسوق',
          style: TextStyle(fontFamily: arabicFontMedium),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          child: Consumer<CartProvider>(
            builder: (context, prov, child) {
              return prov.getProducts.length != 0
                  ? Container(
                      padding: EdgeInsets.all(2),
                      color: accentColor,
                      child: Center(
                        child: Text(
                          "قم بسحب المنتج لليمين أو لليسار للإزالة من السلة",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .apply(color: whiteColor),
                        ),
                      ),
                    )
                  : Container();
            },
          ),
          preferredSize: Size(double.infinity, 10),
        ),
        actions: <Widget>[
          // widget.category
          //     ? Padding(
          //         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.of(context).popUntil((route) => route.isFirst);
          //           },
          //           child: CircleAvatar(
          //             radius: 16,
          //             backgroundColor: whiteColor,
          //             child: Icon(
          //               Icons.home,
          //               color: primaryColor,
          //             ),
          //           ),
          //         ),
          //       )
          //     : Container(),
        ],
      ),
      body: _body(),
      bottomNavigationBar:
          Consumer<CartProvider>(builder: (context, bloc, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: bloc.getProducts.length == 0 ? 0 : 70,
          decoration: BoxDecoration(
              color: lightBGColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              bloc.getProducts.length == 0
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        child: Consumer<GlobalProvider>(
                          builder: (context, prov, child) {
                            return RaisedButton(
                              onPressed: () {
                                Sounds.playSound(3);
                                bloc.setOrderFormat(
                                    prov.user.resturant.location.deliveryCost,
                                    prov.user.resturant.id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ResturantOrderInfo(
                                              type: ResturantOrderInfoType.CART,
                                            )));
                              },
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "${bloc.getProducts.length} منتجات",
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 15),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "تأكيد",
                                        style: TextStyle(
                                            color: whiteColor, fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        color: whiteColor,
                                        size: 35,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }

  _body() {
    return Consumer<CartProvider>(
      builder: (context, bloc, child) {
        return bloc.getProducts.length == 0
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/empty-cart.png',
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "السلة فارغة.. قم بإضافة بعض المنتجات",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    )
                  ],
                ),
              )
            : ListView.builder(
                itemCount: bloc.getProducts.length + 1,
                physics: BouncingScrollPhysics(),
                controller: listviewController,
                itemBuilder: (context, index) {
                  if (index == bloc.getProducts.length) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              subtitle: TextField(
                                style: TextStyle(color: accentColor),
                                minLines: 1,
                                maxLines: 3,
                                onEditingComplete: () {
                                  // print('comp');
                                },
                                controller: bloc.commentController,
                                decoration: InputDecoration(
                                    fillColor: whiteColor,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.2, color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    labelText: " المزيد من التعليمات",
                                    labelStyle:
                                        TextStyle(color: Colors.black12),
                                    contentPadding: EdgeInsets.all(20.0),
                                    hintStyle: TextStyle(
                                        color: accentColor.withOpacity(0.4),
                                        fontSize: 15)),
                              ),
                            ),
                            SizedBox(
                              height: hight,
                            ),
                          ],
                        ));
                  }
                  Product currProduct = bloc.getProducts[index][0];
                  currProduct.pivot = ProductPivot(
                      cost: bloc.getProducts[index][0].cost,
                      quantity: bloc.getProducts[index].length);
                  bloc.getProducts[index].length;
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    controller: slidableController,
                    child: ItemCard(
                      product: currProduct,
                      type: ItemCardType.CART,
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'إزالة من السلة',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          bloc.removeAllProductByIndex(index);
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'إزالة من السلة',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          bloc.removeAllProductByIndex(index);
                        },
                      ),
                    ],
                  );
                });
      },
    );
  }
}
