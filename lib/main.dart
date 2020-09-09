import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/user_model.dart';
import 'package:beda3a/Provider/cart_provider.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Basics/Introduction/introduction.dart';
import 'package:beda3a/Screens/Delivery/delivery_main.dart';
import 'package:beda3a/Screens/Wholesaler/wholesaler_main_page.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:beda3a/Screens/Basics/Login/login_screen.dart';
import 'package:beda3a/Screens/Resturant/resturant_main.dart';
import 'package:beda3a/Screens/Resturant/resturant_order_info.dart';
import 'package:beda3a/Widgets/logo.dart';
import 'package:beda3a/utils/images.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:beda3a/utils/sounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  //Cheak language
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(

          create: (_) => GlobalProvider(),
        ),
      ],
      child: RefreshConfiguration(
        headerBuilder: () =>
            WaterDropHeader(), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
        footerBuilder: () =>
            ClassicFooter(), // Configure default bottom indicator
        headerTriggerDistance: 80.0, // header trigger refresh trigger distance
        springDescription: SpringDescription(
            stiffness: 170,
            damping: 16,
            mass:
                1.9), // custom spring back animate,the props meaning see the flutter api
        maxOverScrollExtent:
            100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
        maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
        enableScrollWhenRefreshCompleted:
            true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
        enableLoadingWhenFailed:
            true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
        hideFooterWhenNotFull:
            false, // Disable pull-up to load more functionality when Viewport is less than one screen
        enableBallisticLoad: true,
        child: MaterialApp(
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child,
            );
          },
          routes: {
            "Login": (BuildContext context) => LoginScreen(),
            "ResturantHome": (BuildContext context) => ResturantMain(),
            "WholesalerMain": (BuildContext context) => WholesalerMain(),
            "DelevaryMain": (BuildContext context) => DeliveryMain(),
            "ResturantOrderInfo": (BuildContext context) =>
                ResturantOrderInfo(),
            "Intro": (BuildContext context) => Introduction(),
          },
          theme: myThemeData,
          debugShowCheckedModeBanner: false,
          title: 'بضاعة',
          home: Welcome(),

        ),
      ),
    );
  }
}


class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  double y, width, height;
  Timer timer;
  String token;
  AppUpdateInfo _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;

  @override
  void initState() {
    y = 500;
    width = height = 0;
    super.initState();
    SharedPref.init(context);
    Sounds.loadSound();

    ApiHelper apiHelper = ApiHelper();
    timer = new Timer(new Duration(seconds: 5), () async {
      checkForUpdate().then((_){
        if(_updateInfo?.updateAvailable == true){
          InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
        }
      } );

      String token = SharedPref.getToken();
      if (token == null) {
        Navigator.pushReplacementNamed(context, 'Intro');
      } else if (token == '') {
        Navigator.pushReplacementNamed(context, 'Login');
      } else {
//  SharedPref.emptyCart();
        //// print(json.decode(SharedPref.getUser()));
        CartProvider cartProv =
        Provider.of<CartProvider>(context, listen: false);
        if(SharedPref.getCart()!=null) {
          cartProv.cartFromJson(SharedPref.getCart());
        }
        GlobalProvider prov =
            Provider.of<GlobalProvider>(context, listen: false);

        User user;
        try {
          print("suer=>>> ${SharedPref.getUser()}");
          user = apiHelper.paseUser(json.decode(SharedPref.getUser()));
        } catch (e) {
          //throw Exception();
          print("test"+e.toString());
          Navigator.pushReplacementNamed(context, 'Login');
        }
        prov.setUser(user);
        prov.userRefresh().then((_) {
          SharedPref.showOpenDialog(prov.scaffoldkey.currentContext);
          print("suer=>>>${user.userId.toString()}");
         cartProv.updateCart(prov.products);
        });
        if (prov.user.active == 0) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            title: 'خطأ',
            desc:
                "لقد تم إلغاء تفعيل حسابك .. يرجى التواصل مع الإدارة والمحاولة مرة أخرى",
          )..show();
        } else {
          if (user.roleId == 3)
            Navigator.pushReplacementNamed(context, 'ResturantHome');
          else if (user.roleId == 4)
            Navigator.pushReplacementNamed(context, 'WholesalerMain');
          else if (user.roleId == 5)

            Navigator.pushReplacementNamed(context, 'DelevaryMain');
        }
      }
    });
    //
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) => _showError(e));
  }

  void _showError(dynamic exception) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(exception.toString())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: primaryColor,
      body: Stack(
        children: <Widget>[
          welcBG,
          AnimatedContainer(
            transform: Matrix4.translationValues(0, 0, 0),
            duration: new Duration(milliseconds: 600),
            curve: Curves.fastLinearToSlowEaseIn,
            child: Center(child: strockLogo(220)),
          ),
        ],
      ),
    );
  }
}
