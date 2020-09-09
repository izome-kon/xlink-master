/*
This is file to any thing for design in app ex.(colors,themeData,gradients...)
*/

import 'package:flutter/material.dart';

// color for facebook logo
Color faceBookColor = Color.fromRGBO(47, 137, 197, 1);
//primary color in app

Color primaryColor = Color.fromRGBO(47, 71, 105, 1);
//accent color in app
Color accentColor = Color.fromRGBO(28, 157, 128, 1);

//white color in app
Color whiteColor = Colors.white;
// light background in app
Color lightBGColor = Color.fromRGBO(229, 248, 244, 1);
//
Color meatColorBar = Color.fromRGBO(255, 202, 73, 1);

// this font used in title text in app
String headerEnglishFont = "headerEnglishFont";
// this font used in subtitle1 text in app
String bodyEnglishFont = "bodyEnglishFont";

// this font used in subtitle1 text in app
String logoFont = "logoFont";
String arabicFontMedium = "arabicFont-Medium";
String arabicFontLight = "arabicFont-Light";
// this is theme for app
ThemeData myThemeData = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    textTheme: TextTheme(
        //caption: TextStyle(fontSize: 24, color: whiteColor),
        headline1: TextStyle(fontFamily: arabicFontMedium),
        headline2: TextStyle(fontFamily: arabicFontMedium),
        headline5: TextStyle(fontFamily: arabicFontMedium),
        bodyText1: TextStyle(fontFamily: arabicFontMedium),
        bodyText2:
            TextStyle(color: Colors.black54, fontFamily: arabicFontMedium),
        subtitle1:
            TextStyle(color: Colors.black38, fontFamily: arabicFontMedium),
        subtitle2: TextStyle(fontFamily: arabicFontMedium),
        button: TextStyle(color: whiteColor, fontFamily: arabicFontMedium)));
//this gradient use for LOGIN State Screen BG
Gradient gradient = RadialGradient(
    radius: 2, colors: [primaryColor, primaryColor.withOpacity(0.99)]);
