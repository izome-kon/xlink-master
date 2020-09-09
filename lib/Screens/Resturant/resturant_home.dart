import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/category_model.dart';
import 'package:beda3a/Models/category_page_model.dart';
import 'package:beda3a/Models/offer_model.dart';
import 'package:beda3a/Models/resturant_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Basics/pop_up.dart';
import 'package:beda3a/Screens/Resturant/category_page.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:beda3a/Widgets/category_button.dart';
import 'package:beda3a/Widgets/my_appbar.dart';
import 'package:beda3a/Widgets/product_card.dart';
import 'package:beda3a/utils/theme.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ResturantHome extends StatefulWidget {
  @override
  _ResturantHomeState createState() => _ResturantHomeState();
}

class _ResturantHomeState extends State<ResturantHome> {
  GlobalProvider prov;

  RefreshController controller = RefreshController();

  @override
  void initState() {
    prov = Provider.of<GlobalProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: prov.scaffoldkey,
      extendBody: true,
      appBar: MyAppBar(),
      body: Consumer<GlobalProvider>(
        builder: (context, prov, child) {
          return SmartRefresher(
            physics: BouncingScrollPhysics(),
            controller: controller,
            header: BezierCircleHeader(
              rectHeight: 30,
              bezierColor: primaryColor,
              enableChildOverflow: true,
            ),
            primary: true,
            onRefresh: () async {
              await prov.userRefresh().then((_) {
                controller.refreshCompleted();
              });
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                    child: prov.user.resturant.offers.length == 0
                        ? Container()
                        : _buildSlider(prov.user.resturant.offers)),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Text("استكشاف الفئات"),
                  ),
                ),
                SliverAppBar(
                    backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                    pinned: true,
                    bottom: PreferredSize(
                      child: Container(
                          padding: EdgeInsets.only(left: 10),
                          height: 95,
                          child: _buildCategories(prov.categories)),
                      preferredSize:
                          Size(MediaQuery.of(context).size.width, 40),
                    )),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 10),
                    child: Text("المنتجات الأكثر شعبية"),
                  ),
                ),
                SliverFixedExtentList(
                  itemExtent: 150, // I'm forcing item heights
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == prov.products.length)
                      return SizedBox(
                        height: 25,
                      );
                    return ProductCard(prov.products[index]);
                  },
                      childCount:
                          prov.products.length + 1 //generatedList.length,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> onRefresh(context) {
    GlobalProvider prov = Provider.of<GlobalProvider>(context, listen: false);
    prov.userRefresh();
  }

  Widget _buildSlider(List<Offer> offer) {
    return Container(
      alignment: Alignment.topCenter,
      height: 210.0,
      child: Consumer<CartProvider>(
        builder: (context, prov, child) {
          return Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text("عروض اليوم"),
              ),
              Container(
                child: new Swiper(
                  itemCount: offer.length,
                  itemHeight: 10,
                  duration: 3000,
                  layout: SwiperLayout.DEFAULT,
                  curve: Curves.easeOutCubic,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        prov.addProduct(offer[index].product);
                        SharedPref.setCart(prov.cartToJson());
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://xlink.ideagroup-sa.com/storage/${offer[index].image}',
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: (MediaQuery.of(context).size.width / 2) - 22,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 1,
                                ),
                                prov
                                            .foundProduct(offer[index].product)
                                            .length !=
                                        0
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
                                                .foundProduct(
                                                    offer[index].product)
                                                .length
                                                .toString(),
                                            style: TextStyle(color: whiteColor),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  pagination: SwiperPagination(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategories(List<Category> category) {
    return Container(
      child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, mainAxisSpacing: 0),
          scrollDirection: Axis.horizontal,
          itemCount: category.length,
          itemBuilder: (BuildContext context, index) {
            return CategoryButton(category[index].image, category[index].name,
                () {
              //CategoryPage
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CategoryPage(category[index])));
            });
          }),
    );
  }
}
