import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:beda3a/utils/sounds.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ScrollController scrollController = ScrollController();
  double titleOpacity = 0;
  Color _appBarColor = primaryColor.withOpacity(0.1);
  Color buttonCollor = primaryColor.withOpacity(1);
  @override
  void initState() {
    scrollController.addListener(() {
      //
      double value = scrollController.position.pixels;
      if (titleOpacity <= 1 &&
          titleOpacity >= 0) if (scrollController.position.pixels <= 0) {
        setState(() {
          titleOpacity = 0;
          _appBarColor = primaryColor.withOpacity(0.1);
          buttonCollor = primaryColor.withOpacity(1);
          return;
        });
      } else if ((value / (MediaQuery.of(context).size.height / 3) < 1)) {
        setState(() {
          titleOpacity = (value / (MediaQuery.of(context).size.height / 3));
          _appBarColor = primaryColor
              .withOpacity(value / (MediaQuery.of(context).size.height / 3));
          buttonCollor = whiteColor
              .withOpacity(value / (MediaQuery.of(context).size.height / 3));
          return;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: buttonCollor),
              expandedHeight: (MediaQuery.of(context).size.height / 3),
              flexibleSpace: FlexibleSpaceBar(
                title: Opacity(
                  opacity: titleOpacity,
                  child: Text(
                    "${widget.product.name}",
                    style: TextStyle(
                        color: whiteColor, fontFamily: arabicFontMedium),
                  ),
                ),
                background: FullScreenWidget(
                  backgroundIsTransparent: true,

                  child: Center(
                    child: Hero(
                      tag: "${widget.product.name}",
                      child:  Container(
                        color: Colors.white,

                        child: new Swiper(
                          itemCount: widget.product.image.length,

                          curve: Curves.easeOutCubic,
                          viewportFraction: 0.8,
                          scale: 0.8,

                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              fit: StackFit.expand,

                              children: <Widget>[
                                Container(
                                  width: 100,
                                  child:  CachedNetworkImage(
                                    imageUrl:   'https://xlink.ideagroup-sa.com/storage/${widget.product.image[index]}',
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.error),

                                  ),
                                ),
                              ],
                            );
                          },
                          customLayoutOption: CustomLayoutOption(startIndex: 0),
                          loop: false,
                          pagination: SwiperPagination(margin: EdgeInsets.only(top: 100)),
                        ),
                      ),

                    ),
                  ),
                ),
                centerTitle: true,
              ),
              backgroundColor: _appBarColor,
              pinned: true,
              centerTitle: true,
            ),
            SliverFillRemaining(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.product.name}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "تفاصيل المنتج",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  widget.product.description == '' || widget.product.description == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Icon(
                                  Icons.not_interested,
                                  size: 100,
                                  color: Colors.grey[300],
                                ),
                                Text('لا يوجد وصف لهذا المنتج')
                              ],
                            ),
                          ],
                        )
                      : Text(
                          "${widget.product.description}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                ],
              ),
            )),
          ]),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, prov, child) {
          int quantity = prov.foundProduct(widget.product).length;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: quantity != 0 ? MediaQuery.of(context).size.height*0.15 : MediaQuery.of(context).size.height*0.1,
            color: whiteColor,
            child: Stack(
              children: [
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 500),
                  transform:
                      Matrix4.translationValues(0, quantity == 0 ? 10 : 0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الكمية الموجودة الآن في السلة",
                          style: TextStyle(color: primaryColor),
                        ),
                        Row(
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.redAccent, // button color
                                child: InkWell(
                                  splashColor: Colors
                                      .redAccent.shade100, // inkwell color
                                  child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Icon(
                                        Icons.remove,
                                        color: whiteColor,
                                      )),
                                  onTap: () {
                                    Sounds.playSound(1);
                                    prov.removeProduct(widget.product,
                                        fource: true);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "$quantity",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 25),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ClipOval(
                              child: Material(
                                color: Colors.green, // button color
                                child: InkWell(
                                  splashColor: accentColor, // inkwell color
                                  child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Icon(
                                        Icons.add,
                                        color: whiteColor,
                                      )),
                                  onTap: () {
                                    Sounds.playSound(2);
                                    prov.addProduct(widget.product);
                                    SharedPref.setCart(prov.cartToJson());
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                quantity != 0
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 70,
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 30,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "السعر",
                                            style: TextStyle(color: whiteColor),
                                          ),
                                          Text(
                                            "${quantity * widget.product.cost} جنية",
                                            style: TextStyle(color: whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: whiteColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "العودة للرئيسية",
                                          style: TextStyle(color: whiteColor),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 70,
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Sounds.playSound(2);
                              prov.addProduct(widget.product);
                            },
                            splashColor: Colors.greenAccent,
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 30,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: whiteColor,
                                    size: 25,
                                  ),
                                  Text(
                                    "أضف إلى السلة",
                                    style: TextStyle(color: whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
