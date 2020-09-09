import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:beda3a/Widgets/switcher.dart';
import 'package:beda3a/utils/theme.dart';

class WholesalerProductCard extends StatefulWidget {
  final Product product;
  WholesalerProductCard(this.product);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<WholesalerProductCard> {
  int count = 1;
  TextEditingController priceController;

  @override
  void initState() {
    priceController =
        new TextEditingController(text: widget.product.cost.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        height: 160,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://xlink.ideagroup-sa.com/storage/${widget.product.image[0]}',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  widget.product.confirmed == 0
                      ? Container(
                          color: Colors.redAccent.withOpacity(0.7),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'بانتظار الموافقة',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ))
                      : Container()
                ],
              ),
              Consumer<GlobalProvider>(
                builder: (context, prov, child) {
                  return Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.product.name,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.product.size,
                            style:
                                TextStyle(color: Colors.black26, fontSize: 15),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            priceController.text + " ج.م",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: showAsBottomSheet,
                                child: Container(
                                  height: 25,
                                  padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "تعديل",
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 16.0),
                                  ),
                                ),
                              ),
                              LiteRollingSwitch(
                                //initial value
                                animationDuration: Duration(milliseconds: 250),
                                value: widget.product.available == 1
                                    ? true
                                    : false,
                                textOn: 'متاح',
                                textOff: 'غير متاح',
                                colorOn: Color.fromRGBO(129, 194, 65, 1),
                                colorOff: Color.fromRGBO(204, 58, 52, 1),
                                iconOn: Icons.done,
                                iconOff: Icons.remove_circle_outline,
                                textSize: 14.0,
                                onChanged: (bool state) {
                                  if (state) {
                                    ApiHelper().fetchUpdate(
                                        prov.user.wholesaler.id,
                                        widget.product.id,
                                        1);
                                    widget.product.available = 1;
                                  } else {
                                    ApiHelper().fetchUpdate(
                                        prov.user.wholesaler.id,
                                        widget.product.id,
                                        0);
                                    widget.product.available = 0;
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ]),
      ),
    );
  }

  void message() {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: Text("تم تحديث المنتج ${widget.product.name} !"),
      backgroundColor: Colors.green,
    ));
  }

  void showAsBottomSheet() async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.9, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Material(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://xlink.ideagroup-sa.com/storage/${widget.product.image[0]}',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    widget.product.confirmed == 0
                        ? Container(
                            color: Colors.redAccent.withOpacity(0.7),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'بانتظار الموافقة',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ))
                        : Container()
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: TextField(
                      controller:
                          TextEditingController(text: widget.product.name),
                      enabled: false,
                      decoration: InputDecoration(
                          fillColor: whiteColor,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          labelText: "اسم المنتج",
                          contentPadding: EdgeInsets.all(20.0),
                          hintStyle: TextStyle(
                              color: accentColor.withOpacity(0.7),
                              fontSize: 15)),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width - 110,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width - 160,
                          height: 50,
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: TextField(
                            enabled: true,
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            decoration: InputDecoration(
                                fillColor: whiteColor,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                labelText: "السعر",
                                contentPadding: EdgeInsets.all(20.0),
                                hintText: widget.product.cost.toString(),
                                hintStyle: TextStyle(
                                    color: accentColor.withOpacity(0.7),
                                    fontSize: 15)),
                          )),
                      Text(
                        "ج.م",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                Consumer<GlobalProvider>(
                  builder: (context, prov, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 55,
                      child: RaisedButton(
                        onPressed: () {
                          ApiHelper()
                              .updateProductCost(
                                  prov.user.wholesaler.id,
                                  widget.product.id,
                                  double.parse(priceController.text))
                              .then((_) {
                            prov.updateProduct(widget.product);
                            Navigator.of(context).pop();
                            message();
                          });
                        },
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "تقديم",
                              style: TextStyle(color: whiteColor, fontSize: 20),
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: whiteColor,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 55,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Color.fromRGBO(112, 112, 112, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "الغاء",
                          style: TextStyle(color: whiteColor, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
        },
      );
    });
  }
}
