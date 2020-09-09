import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/delivey_model.dart';
import 'package:beda3a/Models/orders_page_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Delivery/delivery_main.dart';
import 'package:beda3a/Widgets/item_card.dart';
import 'package:beda3a/utils/theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/global_provider.dart';
import '../../Shared/shared_pref.dart';

enum ResturantOrderInfoType { ORDER, CART, Delivery }
GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

class ResturantOrderInfo extends StatefulWidget {
  final ResturantOrderInfoType type;
  ResturantOrderInfo({this.type: ResturantOrderInfoType.ORDER});

  @override
  _ResturantOrderInfoState createState() => _ResturantOrderInfoState();
}

class _ResturantOrderInfoState extends State<ResturantOrderInfo> {
  List<Widget> productsCard = [];

  var costController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  load() {
    productsCard = [];
    CartProvider prov = Provider.of<CartProvider>(context);
    productsCard.add(OrderHeader(
      order: prov.newOrder,
      type: widget.type,
    ));
    productsCard.add(Container(
      padding: EdgeInsets.only(right: 10),
      child: Row(
        children: <Widget>[
          Text('البضائع ( ${prov.newOrder.product.length} ) :'),
        ],
      ),
    ));
    print(prov.newOrder.product.length);
    for (int i = 0; i < prov.newOrder.product.length; i++) {
      productsCard.add(ItemCard(
        product: prov.newOrder.product[i],
      ));
    }
    productsCard.add(OrderSamary(
      order: prov.newOrder,
    ));
    if (widget.type == ResturantOrderInfoType.CART &&
        (prov.newOrder.discount == null))
      productsCard.add(OrderPromoCode(prov.newOrder));

    print(productsCard.length);
  }

  @override
  Widget build(BuildContext context) {
    load();
    return Consumer<CartProvider>(builder: (context, bloc, child) {
      return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              'تفاصيل الطلب ',
              style: TextStyle(fontFamily: arabicFontMedium),
            ),
            centerTitle: true,
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: productsCard,
          ),
          bottomNavigationBar: Consumer<GlobalProvider>(
            builder: (context, prov, child) {
              return prov.user.roleId == 5
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      decoration: BoxDecoration(
                          color: lightBGColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              topLeft: Radius.circular(30.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: RaisedButton(
                                onPressed: () {
                                  AwesomeDialog(
                                    context: context,
                                    headerAnimationLoop: false,
                                    dialogType: DialogType.INFO,
                                    dismissOnTouchOutside: false,
                                    btnOkOnPress: () {
                                      AwesomeDialog(
                                        context: context,
                                        headerAnimationLoop: false,
                                        dismissOnBackKeyPress: false,
                                        dismissOnTouchOutside: false,
                                        title: 'جاري الطلب',
                                        desc: "برجاء الإنتظار..",
                                        customHeader:
                                            CircularProgressIndicator(),
                                      )..show();
                                      ApiHelper()
                                          .submitDeliveryOrder(
                                              bloc.newOrder.id,
                                              bloc.newOrder.resturant.userId,
                                              bloc.newOrder.total,
                                              double.parse(costController.text))
                                          .then((value) {
                                        Navigator.pop(context);
                                        AwesomeDialog(
                                            context: context,
                                            headerAnimationLoop: false,
                                            dismissOnBackKeyPress: false,
                                            dismissOnTouchOutside: false,
                                            animType: AnimType.SCALE,
                                            dialogType: DialogType.SUCCES,
                                            title: 'تم بنجاح',
                                            desc:
                                                "لقد تم تأكيد تسليم الطلب بنجاح !",
                                            btnOkOnPress: () {
                                              //    Navigator.pushAndRemoveUntil(context, newRoute, )
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          DeliveryMain()),
                                                  (route) => false);
                                            },
                                            btnOkText: 'حسناً')
                                          ..show();
                                      });
                                    },
                                    btnCancelOnPress: () {
                                      costController.text = "";
                                    },
                                    btnCancelText: 'إلغاء',
                                    btnOkText: "تأكيد",
                                    title: 'تأكيد التسليم',
                                    desc:
                                        "الرجاء كتابة المبلغ المستلم من المطعم بعناية",
                                    body: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                              "المجموع الكلي للطلب : ${bloc.newOrder.total}"),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: costController,
                                                decoration: InputDecoration(
                                                    fillColor: whiteColor,
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50))),
                                                    labelText: "المبلغ المدفوع",
                                                    contentPadding:
                                                        EdgeInsets.all(20.0),
                                                    hintStyle: TextStyle(
                                                        color: accentColor
                                                            .withOpacity(1),
                                                        fontSize: 15)),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )..show();
                                  // bloc.ordering().then((value) {
                                  //   print(bloc.orderingState);
                                  //   Navigator.pop(context);
                                  //   if (bloc.orderingState ==
                                  //       SendOrderState.SUCCEES)
                                  //     AwesomeDialog(
                                  //         context: context,
                                  //         headerAnimationLoop: false,
                                  //         dismissOnBackKeyPress: false,
                                  //         dismissOnTouchOutside: false,
                                  //         animType: AnimType.SCALE,
                                  //         dialogType: DialogType.SUCCES,
                                  //         title: 'تم بنجاح',
                                  //         desc: "لقد تم إرسال الطلب بنجاح !",
                                  //         btnOkOnPress: () {
                                  //           bloc.emptyCart();
                                  //           Navigator.popUntil(
                                  //               context,
                                  //               ModalRoute.withName(
                                  //                   'ResturantHome'));
                                  //         },
                                  //         btnOkText: 'حسناً')
                                  //       ..show();
                                  //   else if (bloc.orderingState ==
                                  //       SendOrderState.ERROR)
                                  //     AwesomeDialog(
                                  //       context: context,
                                  //       headerAnimationLoop: false,
                                  //       autoHide: Duration(seconds: 3),
                                  //       animType: AnimType.SCALE,
                                  //       dialogType: DialogType.ERROR,
                                  //       title: 'خطأ',
                                  //       desc:
                                  //           "للأسف حدث خطأ .. حاول مرة اخرى لاحقاً",
                                  //     )..show();
                                  // });
                                },
                                color: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "تسليم الطلب",
                                          style: TextStyle(
                                              color: whiteColor, fontSize: 20),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : widget.type == ResturantOrderInfoType.CART
                      ? Container(
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 55,
                                        child: RaisedButton(
                                          onPressed: () {
                                            AwesomeDialog(
                                              context: context,
                                              headerAnimationLoop: false,
                                              dismissOnBackKeyPress: false,
                                              dismissOnTouchOutside: false,
                                              title: 'جاري الطلب',
                                              desc: "برجاء الإنتظار..",
                                              customHeader:
                                                  CircularProgressIndicator(),
                                            )..show();
                                            bloc.ordering().then((value) {
                                              // print(bloc.orderingState);
                                              Navigator.pop(context);
                                              if (bloc.orderingState ==
                                                  SendOrderState.SUCCEES)
                                                AwesomeDialog(
                                                    context: context,
                                                    headerAnimationLoop: false,
                                                    dismissOnBackKeyPress:
                                                        false,
                                                    dismissOnTouchOutside:
                                                        false,
                                                    animType: AnimType.SCALE,
                                                    dialogType:
                                                        DialogType.SUCCES,
                                                    title: 'تم بنجاح',
                                                    desc:
                                                        "لقد تم إرسال الطلب بنجاح !",
                                                    btnOkOnPress: () {
                                                      bloc.emptyCart();
                                                      Navigator.popUntil(
                                                          context,
                                                          ModalRoute.withName(
                                                              'ResturantHome'));
                                                    },
                                                    btnOkText: 'حسناً')
                                                  ..show();
                                              else if (bloc.orderingState ==
                                                  SendOrderState.ERROR)
                                                AwesomeDialog(
                                                  context: context,
                                                  headerAnimationLoop: false,
                                                  autoHide:
                                                      Duration(seconds: 3),
                                                  animType: AnimType.SCALE,
                                                  dialogType: DialogType.ERROR,
                                                  title: 'خطأ',
                                                  desc:
                                                      "للأسف حدث خطأ .. حاول مرة اخرى لاحقاً",
                                                )..show();
                                            });
                                          },
                                          color: primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "أطلب الآن",
                                                    style: TextStyle(
                                                        color: whiteColor,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        )
                      : Row();
            },
          ));
    });
  }
}

class OrderHeader extends StatelessWidget {
  final Order order;
  final ResturantOrderInfoType type;
  OrderHeader({this.order, this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                    type == ResturantOrderInfoType.ORDER ||
                            type == ResturantOrderInfoType.Delivery
                        ? 'رقم الطلب :  #${order.id}'
                        : 'طلب جديد',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .apply(fontFamily: arabicFontMedium)),
                Spacer(),
                type == ResturantOrderInfoType.ORDER ||
                        type == ResturantOrderInfoType.Delivery
                    ? Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              order.checkDelivery != null
                                  ? Icons.check_circle
                                  : Icons.timer,
                              color: order.checkDelivery != null
                                  ? Colors.green
                                  : primaryColor,
                            ),
                            Text(
                              order.checkDelivery == null
                                  ? "جاري التحضير"
                                  : "تم التوصيل",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black26),
                            borderRadius: BorderRadius.circular(50)),
                      )
                    : Container(),
              ],
            ),
            Text(
                'تاريخ الطلب : ${order.createdAt.day} / ${order.createdAt.month} / ${order.createdAt.year}'),
            //Text('${widget.order.product.length} منتجات'),

            type == ResturantOrderInfoType.Delivery
                ? Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text('اسم المطعم : ${order.resturant.name}'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('المنطقة : ${order.resturant.location.address}'),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        child: IconButton(
                            icon: Icon(Icons.phone),
                            color: Colors.white,
                            onPressed: () {
                              print(order.resturant.phone);
                              SharedPref.launchURL(
                                  order.resturant.phone.toString());
                            }),
                      )
                    ],
                  )
                : Container(),

            Divider(),
            Consumer<GlobalProvider>(
              builder: (context, prov, child) {
                return Row(
                  children: <Widget>[
                    Text('المجموع الكلي ',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .apply(fontSizeFactor: 1.3)
                            .apply(fontFamily: arabicFontMedium)),
                    Spacer(),
                    Text(
                        prov.user.wholesaler == null
                            ? '${order.total.toStringAsFixed(1)} جنية'
                            : '${((order.total) - (order.deliveryCost)).toStringAsFixed(1)} جنية',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .apply(fontSizeFactor: 1.3)
                            .apply(fontFamily: arabicFontMedium)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSamary extends StatelessWidget {
  final Order order;
  OrderSamary({this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            order.comment != null && order.comment != 'null'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('المزيد من التعليمات',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .apply(fontSizeFactor: 0.9)
                              .apply(fontFamily: arabicFontMedium)),
                      Text('${order.comment}',
                          style: Theme.of(context).textTheme.subtitle2.apply(
                              fontFamily: arabicFontMedium,
                              color: accentColor)),
                    ],
                  )
                : Container(),
            Divider(
              color: Colors.black54,
            ),
            Row(
              children: <Widget>[
                Text('المجموع',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .apply(fontSizeFactor: 1.3)
                        .apply(fontFamily: arabicFontMedium)),
                Spacer(),
                Text('${order.subtotal.toStringAsFixed(1)} جنية',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .apply(fontSizeFactor: 1.3)
                        .apply(fontFamily: arabicFontMedium)),
              ],
            ),
            Divider(
              color: Colors.black54,
            ),
            Consumer<GlobalProvider>(
              builder: (context, prov, child) {
                return prov.user.wholesaler != null
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('التوصيل',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .apply(fontSizeFactor: 1.3)
                                      .apply(fontFamily: arabicFontMedium)),
                              Spacer(),
                              Text(
                                  '${order.deliveryCost.toStringAsFixed(1)} جنية',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .apply(fontSizeFactor: 1.3)
                                      .apply(fontFamily: arabicFontMedium)),
                            ],
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Row(
                            children: <Widget>[
                              Text('المجموع الكلي ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .apply(fontSizeFactor: 1.3)
                                      .apply(fontFamily: arabicFontMedium)),
                              Spacer(),
                              order.discount != 0 && order.discount != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        prov.user.wholesaler != null
                                            ? Container()
                                            : Container(
                                                padding: EdgeInsets.all(3),
                                                color: Colors.green,
                                                child: Text(
                                                    'خصم ${order.discount.toStringAsFixed(1)} جنية',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .apply(
                                                            fontSizeFactor: 0.9,
                                                            color: whiteColor)
                                                        .apply(
                                                            fontFamily:
                                                                arabicFontMedium)),
                                              ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            '${order.total.toStringAsFixed(1)} جنية',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .apply(fontSizeFactor: 1.3)
                                                .apply(
                                                    fontFamily:
                                                        arabicFontMedium)),
                                      ],
                                    )
                                  : Text(
                                      '${order.total.toStringAsFixed(1)} جنية',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .apply(fontSizeFactor: 1.3)
                                          .apply(fontFamily: arabicFontMedium)),
                            ],
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPromoCode extends StatefulWidget {
  final Order order;
  OrderPromoCode(this.order);

  @override
  _OrderPromoCodeState createState() => _OrderPromoCodeState();
}

class _OrderPromoCodeState extends State<OrderPromoCode> {
  final TextEditingController promocodeController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // print(widget.order.discount);
    return widget.order.discount != null
        ? Container()
        : Card(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Consumer<GlobalProvider>(
                builder: (context, prov, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('لديك كود خصم ؟'),
                      Consumer<CartProvider>(
                          builder: (context, cartProv, child) {
                        return TextField(
                          style: TextStyle(color: accentColor),
                          controller: promocodeController,
                          enabled: !loading,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.local_offer), //loyalty
                              fillColor: whiteColor,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: loading
                                    ? CircularProgressIndicator()
                                    : RaisedButton(
                                        onPressed: () async {
                                          setState(() {
                                            loading = true;
                                          });
                                          List<String> promos = prov
                                              .user.resturant.listOfPromo
                                              .split(' ');
                                          bool found = false;

                                          for (var item in promos) {
                                            if (item ==
                                                promocodeController.text) {
                                              found = true;
                                              break;
                                            }
                                          }
                                          if (found) {
                                            await ApiHelper()
                                                .fetchPromoCode(
                                                    promocodeController.text)
                                                .then((value) {
                                              print(value.required);
                                              if (value.required >
                                                  widget.order.total) {
                                                AwesomeDialog(
                                                  context: context,
                                                  animType: AnimType.SCALE,
                                                  dialogType:
                                                      DialogType.WARNING,
                                                  headerAnimationLoop: false,
                                                  title: 'تنبيه !',
                                                  desc:
                                                      "يجب أن لا يقل المجموع الكلي للطلب عن ${value.required} جنيه",
                                                )..show();
                                              } else {
                                                cartProv.setPromoCode(
                                                    value.discount,
                                                    widget.order.deliveryCost);

                                                AwesomeDialog(
                                                    context: context,
                                                    animType: AnimType.SCALE,
                                                    dialogType:
                                                        DialogType.SUCCES,
                                                    headerAnimationLoop: false,
                                                    title: 'تم بنجاح',
                                                    desc:
                                                        "تم إضافة كود خصم بقيمة ${value.discount} جنية")
                                                  ..show();
                                              }
                                            });
                                          } else {
                                            AwesomeDialog(
                                              context: context,
                                              animType: AnimType.SCALE,
                                              dialogType: DialogType.ERROR,
                                              headerAnimationLoop: false,
                                              title: 'خطأ',
                                              desc: "أنت لا تمتلك هذا الكود",
                                            )..show();
                                          }
                                          setState(() {
                                            loading = false;
                                          });
                                        },
                                        color: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Text(
                                          "تقديم",
                                          style: TextStyle(
                                              color: whiteColor, fontSize: 16),
                                        ),
                                      ),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.2, color: Colors.black12),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              contentPadding: EdgeInsets.all(20.0),
                              hintText: 'أدخل كود الخصم هنا',
                              hintStyle: TextStyle(
                                  color: accentColor.withOpacity(0.4),
                                  fontSize: 15)),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          );
  }
}
