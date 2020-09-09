import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Screens/Basics/product_details.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beda3a/utils/sizeConfige.dart';
import 'package:beda3a/utils/sounds.dart';
import 'package:beda3a/utils/theme.dart';

import '../utils/theme.dart';

class ProductCard extends StatelessWidget {
  int count = 1;

  Sounds sound;
  Product _product;
  ProductCard(this._product);

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Card(
      margin: EdgeInsets.all(1),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProductDetails(product: this._product)));
        },
        child: Container(
          padding: const EdgeInsets.all(0),
          margin: EdgeInsets.all(10),
          height: 150,
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                child:CachedNetworkImage(
                  imageUrl:  'https://xlink.ideagroup-sa.com/storage/${_product.image[0]}',
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),

                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              _product.name,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            _product.cost.toString() + " ج.م",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      _product.size==null?Container():
                      Row(
                        children: <Widget>[
                          Text(_product.size.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ))
                        ],
                      ),
                      //Spacer(),
                      Consumer<CartProvider>(
                        builder: (context, prov, child) {
                          return Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  prov.foundProduct(_product).length != 0
                                      ? InkWell(
                                          onTap: () {
                                            Sounds.playSound(1);
                                            prov.removeProduct(_product,
                                                fource: true);
                                          },
                                          splashColor:
                                              Colors.redAccent.shade200,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.redAccent,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  prov.foundProduct(_product).length != 0
                                      ? Card(
                                          color: accentColor,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 5,
                                                right: 8.0,
                                                left: 8),
                                            child: Text(
                                              prov
                                                  .foundProduct(_product)
                                                  .length
                                                  .toString(),
                                              style:
                                                  TextStyle(color: whiteColor),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Spacer(),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                color: primaryColor,
                                elevation: 0.3,
                                textColor: whiteColor,
                                child: Text(
                                  "أضف للسلة",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .apply(fontSizeFactor: 0.9),
                                ),
                                onPressed: () {
                                  Sounds.playSound(2);
                                  prov.addProduct(_product);
                                  SharedPref.setCart(prov.cartToJson());
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
