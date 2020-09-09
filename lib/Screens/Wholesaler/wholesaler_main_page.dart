import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Screens/Basics/Profile/profile.dart';
import 'package:beda3a/Screens/Basics/connect_us.dart';
import 'package:beda3a/Screens/Wholesaler/wholesaler_home.dart';
import 'package:beda3a/Screens/Wholesaler/wholesaler_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beda3a/utils/images.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../Helper/api_helper.dart';
import '../../Provider/global_provider.dart';

class WholesalerMain extends StatefulWidget {
  get showAsBottomSheet => null;

  @override
  _WholesalerMainPageState createState() => _WholesalerMainPageState();
}

class _WholesalerMainPageState extends State<WholesalerMain> {
  TextEditingController name;
  TextEditingController image;
  TextEditingController cost;
  TextEditingController des;
  PageController _pageController;
  int _pageIndex;
  File _imageFile;

  File _croppedImage;

  bool search = false;

  double searchBoxWidthFactor = 0.0;
  double serchIconSizeFactor = 1;
  var focusNode = new FocusNode();
  var searchController = TextEditingController();
  double searchFontSizeFactor = 0;
  @override
  void initState() {
    name = TextEditingController();
    cost = TextEditingController();
    des = TextEditingController();
    _pageController = new PageController();
    _pageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: <Widget>[
          // _yourProductsBody(),
          WholesalerHome(),
          WholesalerOrders(),
          ConnectUs(),
          Profile(),
        ],
      ),
      floatingActionButton: _pageIndex == 0
          ? FloatingActionButton(
              onPressed: showAsBottomSheet,
              backgroundColor: primaryColor,
              child: Icon(
                Icons.add,
                size: 35,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          selectedItemColor: accentColor,
          unselectedItemColor: primaryColor,
          onTap: (index) {
            setState(() {
              _pageController.jumpToPage(index);
              _pageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("منتجاتك")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("قائمة الطلبات")),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), title: Text("تواصل معنا")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("الملف الشخصي")),
          ]),
    );
  }

  Future<void> _pickImage() async {
    Navigator.of(context).pop();
    await ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _imageFile = value;
        _croppedImage = value;
      });
      showAsBottomSheet();
    });
  }

  Future<void> _cropImage() async {
    Navigator.of(context).pop();
    await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'قص الصورة',
          toolbarWidgetColor: whiteColor,
          toolbarColor: primaryColor),
      sourcePath: _imageFile.path,
    ).then((value) {
      setState(() {
        _croppedImage = value ?? _imageFile;
      });
      showAsBottomSheet();
    });
  }

  void showAsBottomSheet() async {
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
          return Material(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _croppedImage != null
                    ? Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Image.file(
                            _croppedImage,
                            width: 150,
                            height: 150,
                          ),
                          CircleAvatar(
                              backgroundColor: primaryColor,
                              child: IconButton(
                                  color: whiteColor,
                                  icon: Icon(Icons.crop),
                                  onPressed: _cropImage))
                        ],
                      )
                    : InkWell(
                        child: addPhoto,
                        onTap: _pickImage,
                      ),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: TextField(
                      controller: name,
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
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: TextField(
                      maxLines: 3,
                      minLines: 3,
                      controller: des,
                      decoration: InputDecoration(
                          fillColor: whiteColor,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: "الوصف",
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
                            keyboardType: TextInputType.number,
                            controller: cost,
                            decoration: InputDecoration(
                                fillColor: whiteColor,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                labelText: "السعر",
                                contentPadding: EdgeInsets.all(20.0),
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
                          if (name.text == '' || cost.text == '') {
                            AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              autoHide: Duration(seconds: 3),
                              animType: AnimType.SCALE,
                              dialogType: DialogType.ERROR,
                              title: 'خطأ',
                              desc: "يجب إدخال اسم للمنتج وسعره",
                            )..show();
                          } else {
                            AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              dismissOnBackKeyPress: false,
                              dismissOnTouchOutside: false,
                              title: 'جاري إضافة منتج',
                              desc: "برجاء الإنتظار..",
                              customHeader: CircularProgressIndicator(),
                            )..show();

                            ApiHelper()
                                .addProduct(
                                    prov.user.wholesaler.id,
                                    name.text,
                                    des.text,
                                    cost.text,
                                    _croppedImage,
                                    'product')
                                .then((value) {
                              name.text = cost.text = des.text = "";
                              _croppedImage = null;
                              _imageFile = null;
                              prov.userRefresh();
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
                                      "لقد تم إرسال المنتج إلى الإدارة للمراجعة !",
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                  btnOkText: 'حسناً')
                                ..show();
                            });
                          }
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
                      setState(() {
                        name.text = "";
                        cost.text = "";
                        des.text = '';
                        _croppedImage = null;
                        _imageFile = null;
                      });
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

  searchSubmit(String text) {
    setState(() {
      focusNode.unfocus();
      search = false;
      searchBoxWidthFactor = 0.0;
      serchIconSizeFactor = 1;
      searchFontSizeFactor = 0;
      var string = text.trim();
      if (string.isNotEmpty) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) =>
        //             WholesalerSearchPage(searchController.text)));
      }
    });
  }
}
