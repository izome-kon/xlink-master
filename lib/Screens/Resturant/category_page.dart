import 'package:avatar_glow/avatar_glow.dart';
import 'package:badges/badges.dart';
import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/category_model.dart';
import 'package:beda3a/Models/category_page_model.dart';
import 'package:beda3a/Models/product_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Resturant/resturant_cart.dart';
import 'package:beda3a/Widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';
import '../../utils/theme.dart';
import '../../utils/theme.dart';
import '../../utils/theme.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
  CategoryPage(this.category);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool loaded = false;
  List<Widget> pages = List<Widget>();
  List<Widget> tabs = List<Widget>();
  bool search = false;
  List<CategoryPageModel> _categoryPageModel;
  GlobalProvider prov;
  @override
  void initState() {
    prov = Provider.of<GlobalProvider>(context, listen: false);
    load();
    super.initState();
  }

  load() async {
    _categoryPageModel =
        await ApiHelper().ferchCategoryPage(widget.category.id);
    tabs.add(Text(
      'الكل',
      style: TextStyle(fontSize: 18, fontFamily: arabicFontMedium),
    ));
    List<Widget> products = [];
    for (CategoryPageModel cat in _categoryPageModel) {
      for (int i = 0; i < cat.products.length; i++) {
        cat.products[i] = prov.foundProduct(cat.products[i]);
        if (cat.products[i] == null) {
          cat.products.removeAt(i);
          continue;
        } else {
          products.add(ProductCard(cat.products[i]));
        }
      }
    }
    products.add(SizedBox(
      height: 100,
    ));
    pages.add(ListView(
      physics: BouncingScrollPhysics(),
      children: products,
    ));

    for (int i = 1; i < _categoryPageModel.length; i++) {
      tabs.add(Text(
        _categoryPageModel[i].name,
        style: TextStyle(fontSize: 18, fontFamily: arabicFontMedium),
      ));
      List<Widget> products = [];
      for (Product pro in _categoryPageModel[i].products)
        products.add(ProductCard(pro));
      products.add(SizedBox(
        height: 100,
      ));
      pages.add(ListView(
        physics: BouncingScrollPhysics(),
        children: products,
      ));
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Consumer<CartProvider>(
        builder: (context, prov, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.category.name,
                style: TextStyle(fontFamily: arabicFontMedium),
              ),
              centerTitle: true,
            ),
            extendBody: true,
            body: _body(),
            floatingActionButton: prov.getProducts.length == 0
                ? null
                : AvatarGlow(
                    glowColor: primaryColor,
                    endRadius: 40.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Badge(
                      animationType: BadgeAnimationType.scale,
                      elevation: 1,
                      shape: BadgeShape.square,
                      borderRadius: 10,
                      badgeContent: Text(
                        '${prov.getProducts.length}',
                        style: TextStyle(color: whiteColor),
                      ),
                      child: FloatingActionButton(
                        elevation: 10,
                        tooltip: 'السلة',
                        backgroundColor: primaryColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ResturantCart()));
                        },
                        child: Icon(Icons.shopping_cart),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  _body() {
    return Container(
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: !loaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TabBar(
                  isScrollable: true,
                  indicatorColor: primaryColor,
                  labelColor: accentColor,
                  tabs: tabs,
                  labelPadding: EdgeInsets.all(8),
                  indicatorWeight: 2,
                  physics: BouncingScrollPhysics(),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 110,
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: pages,
                  ),
                ),
              ],
            ),
    );
  }
}
