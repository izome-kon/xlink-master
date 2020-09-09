import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beda3a/utils/sounds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ItemCardType { ORDER, CART }

class ItemCard extends StatelessWidget {
  final Product product;
  final ItemCardType type;
  ItemCard({this.product, this.type: ItemCardType.ORDER});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6),
      height: type != ItemCardType.CART ? 114 : 129,
      child: Card(
        elevation: 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(4.0)),
              child: Container(
                width: 100,
                height: type != ItemCardType.CART ? 110 : 140,
                child:CachedNetworkImage(
                  imageUrl:  'https://xlink.ideagroup-sa.com/storage/${product.image[0]}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),

                ),
              ),
              //  Container(
              //   width: 100,
              //   height: type != ItemCardType.CART ? 110 : 140,
              //   child: Image.network(
              //     'https://xlink.ideagroup-sa.com/storage/${product.image[0]}',
              //     fit: BoxFit.cover,
              //     loadingBuilder: (BuildContext context, Widget child,
              //         ImageChunkEvent loadingProgress) {
              //       if (loadingProgress == null) return child;
              //       return Center(
              //         child: CircularProgressIndicator(
              //           value: loadingProgress.expectedTotalBytes != null
              //               ? loadingProgress.cumulativeBytesLoaded /
              //                   loadingProgress.expectedTotalBytes
              //               : null,
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                      child: Text(
                        '${product.name}',
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                      child: Text(
                        '${product.pivot.cost.toStringAsFixed(1)} ج.م',
                        style: TextStyle(color: accentColor, fontSize: 16),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    color: accentColor.withOpacity(0.2),
                    height: type == ItemCardType.CART ? 40 : 25,
                    child: Consumer<CartProvider>(
                      builder: (context, prov, child) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            type == ItemCardType.CART
                                ? Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Sounds.playSound(1);
                                          if (prov.removeProduct(product) ==
                                              -1) {
                                            AwesomeDialog(
                                                context: context,
                                                headerAnimationLoop: false,
                                                dismissOnBackKeyPress: false,
                                                dismissOnTouchOutside: false,
                                                animType: AnimType.SCALE,
                                                dialogType: DialogType.WARNING,
                                                title: 'تنبيه',
                                                desc:
                                                    "سيتم إزالة المنتج من السلة",
                                                btnOkOnPress: () {
                                                  prov.removeProduct(product,
                                                      fource: true);
                                                },
                                                btnCancelOnPress: () {},
                                                btnCancelText: 'إلغاء',
                                                btnOkText: 'تأكيد')
                                              ..show();
                                          }
                                        },
                                        splashColor: Colors.redAccent.shade200,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.redAccent,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      Card(
                                        color: accentColor,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 5,
                                              right: 8.0,
                                              left: 8),
                                          child: Text(
                                            product.pivot.quantity.toString(),
                                            style: TextStyle(color: whiteColor),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Sounds.playSound(1);
                                          prov.addProduct(product);
                                          SharedPref.setCart(prov.cartToJson());
                                        },
                                        splashColor: Colors.green.shade200,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.add,
                                              color: primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          'الكمية : ${product.pivot.quantity}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                            Spacer(),
                            Text(
                                '${(product.pivot.cost * product.pivot.quantity).toStringAsFixed(1)} جنية  ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
