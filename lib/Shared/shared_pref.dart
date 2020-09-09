import 'dart:convert';

import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/location_model.dart';
import 'package:beda3a/Models/offer_model.dart';
import 'package:beda3a/Models/user_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Basics/pop_up.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beda3a/Models/notification_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedPref {
  static SharedPreferences sharedPreferences;
  static List<DropdownMenuItem<Location>> items = [];
  static Location myLocation;
  static String deviceToken;
  static FirebaseMessaging _messaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static Future<void> loadLocations() async {
    myLocation = null;
    if (items.length == 0) {
      await ApiHelper().allLocations().then((value) {
        for (Location location in value) {
          items.add(DropdownMenuItem(
              value: location,
              child: Text(
                location.address,
                style: TextStyle(
                    color: Colors.black54, fontSize: 16, letterSpacing: 5),
              )));
        }
      });
    }
  }
  static void showOpenDialog(context) {
    Offer pops =  Provider.of<GlobalProvider>(context,listen: false).user.resturant.popUpoffers;
    if(pops != null){
      showDialog(
          context: context,
          builder: (context) {
            return PopUp(popsUp: pops,);
          });
    }

  }

  static getCart(){
    return sharedPreferences.getString('cart');
  }

  static setCart(String str){
    sharedPreferences.setString('cart',str );
    print('donnne');
  }

  static emptyCart(){
    sharedPreferences.remove('cart');
  }

  static init(context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings);
    GlobalProvider prov = Provider.of<GlobalProvider>(context, listen: false);
    loadLocations();
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // notBloc = Provider.of<NotifcationsModul>(context);
        var android = AndroidNotificationDetails(
            'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
        var iOS = IOSNotificationDetails();
        var platform = NotificationDetails(android, iOS);
        flutterLocalNotificationsPlugin.show(
            0,
            message['notification']['title'],
            message['notification']['body'],
            platform);
        print("hello");
        NotificationBloc notificationBloc =
            await ApiHelper().fetchNotifcations(prov.user.userId);
        prov.setNotification(notificationBloc);
      },
      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   print("onBackgroundMessage: $message");
      // },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        NotificationBloc notificationBloc =
            await ApiHelper().fetchNotifcations(prov.user.userId);
        prov.setNotification(notificationBloc);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        NotificationBloc notificationBloc =
            await ApiHelper().fetchNotifcations(prov.user.userId);
        prov.setNotification(notificationBloc);
      },
    );
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _messaging.getToken().then((value) {
      deviceToken = value;
      print(value);
    });
  }

  static getToken() {
    return sharedPreferences.getString('token');
  }

  static setToken(String s) {
    sharedPreferences.setString('token', s);
  }

  static logOut() {
    sharedPreferences.setString('token', '');
    sharedPreferences.remove('user');
  }

  static setUser(User user) {
    String s = json.encode(user.userToJson());
    sharedPreferences.setString('user', s);
  }

  static getUser() {
    return sharedPreferences.getString('user');
  }

  static launchURL(String phoneNum) async {
    String url = 'tel: +20$phoneNum';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
