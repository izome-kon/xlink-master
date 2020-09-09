import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Libraries/Flutter_Login/flutter_login.dart';
import 'package:beda3a/Models/delivey_model.dart';
import 'package:beda3a/Models/notification_model.dart';
import 'package:beda3a/Models/resturant_model.dart';
import 'package:beda3a/Models/wholesaler_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, prov, child) {
      SharedPref.init(context);
      return FlutterLogin(
        title: "",
        messages: LoginMessages(
          usernameHint: "رقم الهاتف",
          passwordHint: 'كلمة المرور',
          confirmPasswordHint: 'تأكيد كلمة المرور',
          recoverPasswordButton: 'تأكيد',
          forgotPasswordButton: 'نسيت كلمة المرور؟',
          nameHint: "الاسم",
          resturantNameHint: "اسم المطعم",
          loginButton: "تسجيل الدخول",
          signupButton: "حساب جديد",
          confirmPasswordError: "كلمة المرور غير متطابقة!",
        ),
        logo: 'assets/images/logoLight.gif',

        onLogin: (data) {
          return ApiHelper().login(
            phoneNumber: int.parse(data.name),
            password: data.password,
            deviceToken: SharedPref.deviceToken,
          );
        },
        onSignup: (data) {
          return ApiHelper().signUp(data.userName, int.parse(data.name),
              data.password, data.resturantName, data.locationId);
        },
        //  theme: LoginTheme(primaryColor: primaryColor),
        onSubmitAnimationCompleted: () async {
          prov.setUser(ApiHelper().paseUser(ApiHelper().response.data['user']));

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
            if (prov.user is Resturant) {
              Navigator.pushReplacementNamed(context, 'ResturantHome');

              prov.setCategories(ApiHelper()
                  .paseCategory(ApiHelper().response.data['categories']));
              prov.setProducts(ApiHelper()
                  .paseProduct(ApiHelper().response.data['products']));
              NotificationBloc notificationBloc =
                  await ApiHelper().fetchNotifcations(prov.user.userId);
              prov.setNotification(notificationBloc);
              for (int i = 0; i < prov.user.resturant.offers.length; i++) {
                for (int j = 0; j < prov.products.length; j++) {
                  if (prov.user.resturant.offers[i].product.id ==
                      prov.products[j].id) {
                    prov.products[j].cost = prov.user.resturant.offers[i];
                    break;
                  }
                }
              }
              SharedPref.setUser(prov.user);
              print(SharedPref.getToken());
              await Jiffy.locale('ar');
              SharedPref.showOpenDialog(prov.scaffoldkey.currentContext);
            } else if (prov.user is Wholesaler) {
              prov.setProducts(ApiHelper().paseProduct(
                  ApiHelper().response.data['products']['original']));
              Navigator.pushReplacementNamed(context, 'WholesalerMain');
              SharedPref.setUser(prov.user);
              await Jiffy.locale('ar');
            } else if (prov.user is Delivery) {
              Navigator.pushReplacementNamed(context, 'DelevaryMain');
              SharedPref.setUser(prov.user);

              await Jiffy.locale('ar');
            }
          }
        },
        onRecoverPassword: null,
      );
    });
  }
}
