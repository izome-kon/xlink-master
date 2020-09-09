import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Basics/notifcations.dart';
import 'package:beda3a/Screens/Resturant/resturant_search_page.dart';
import 'package:beda3a/Screens/Wholesaler/wholesaler_search_page.dart';
import 'package:beda3a/Widgets/logo.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

enum AppBarType { RESTURANT, WHOLESALER }

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final AppBarType type;
  MyAppBar(
      {Key key, this.title: "بــضــاعــة", this.type: AppBarType.RESTURANT});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  bool search = false;
  double searchBoxWidthFactor = 0.0;
  double serchIconSizeFactor = 1;
  var focusNode = new FocusNode();
  var searchController = TextEditingController();
  double searchFontSizeFactor = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: SafeArea(
        //minimum: EdgeInsets.only(top: 30),
        child: Stack(
          children: <Widget>[
            !search
                ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontFamily: arabicFontMedium,
                          color: whiteColor,
                          fontSize: 25),
                    ),
                  )
                : Container(),
            Align(
              alignment: widget.type == AppBarType.WHOLESALER
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                    widget.type == AppBarType.WHOLESALER && search
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.end,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(
                      milliseconds: 400,
                    ),
                    width: MediaQuery.of(context).size.width *
                        searchBoxWidthFactor,
                    height: 37,
                    child: TextField(
                      scrollPadding: EdgeInsets.all(0),
                      focusNode: focusNode,
                      controller: searchController,
                      onSubmitted: searchSubmit,
                      style: TextStyle(
                          fontSize: 20 * searchFontSizeFactor,
                          color: whiteColor),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 5, left: 5),
                        labelText: "البحث",
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 17),
                        fillColor: Colors.white,
                        //filled: true,

                        suffixIcon: search
                            ? IconButton(
                                icon: Icon(Icons.search),
                                color: whiteColor,
                                onPressed: () {
                                  searchSubmit(searchController.text);
                                },
                              )
                            : null,

                        focusColor: Colors.white,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1)),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    width: 50 * serchIconSizeFactor,
                    height: 45 * serchIconSizeFactor,
                    duration: Duration(milliseconds: 400),
                    child: IconButton(
                        iconSize: 30 * serchIconSizeFactor,
                        icon: Icon(
                          Icons.search,
                          color: whiteColor,
                        ),
                        onPressed: () {
                          setState(() {
                            search = true;
                            searchBoxWidthFactor = 0.8;
                            serchIconSizeFactor = 0;
                            focusNode.requestFocus();
                            searchFontSizeFactor = 1;
                          });
                        }),
                  ),
                  widget.type == AppBarType.WHOLESALER
                      ? Container()
                      : Consumer<GlobalProvider>(
                          builder: (context, prov, child) {
                            return IconButton(
                                iconSize: 30,
                                icon: Stack(
                                  children: <Widget>[
                                    Icon(
                                      Icons.notifications_none,
                                      color: whiteColor,
                                    ),
                                    prov.unReadNotifications() != 0
                                        ? Positioned(
                                            right: 7,
                                            child: CircleAvatar(
                                                child: Text(
                                                  "${prov.unReadNotifications()}",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: whiteColor),
                                                ),
                                                radius: 8,
                                                backgroundColor:
                                                    Colors.redAccent),
                                          )
                                        : Container()
                                  ],
                                ),
                                onPressed: () async {
                                  // print(prov.notifications.id);
                                  await ApiHelper()
                                      .readNotifcations(prov.notifications.id);
                                  showNotifcation();
                                  prov.readNotifications();
                                });
                          },
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  searchSubmit(String text) {
    setState(() {
      focusNode.unfocus();
      search = false;
      searchBoxWidthFactor = 0.0;
      serchIconSizeFactor = 1;
      searchFontSizeFactor = 0;
      var string = text.trim();
      if (string.isNotEmpty) {
        if (widget.type == AppBarType.RESTURANT)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ResturantSearchPage(searchController.text)));
        else if (widget.type == AppBarType.WHOLESALER)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      WholesalerSearchPage(searchController.text)));
      }
    });
  }

  void showNotifcation() async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.9, 0.9, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Notifcations();
        },
      );
    });
  }
}
