import 'package:flutter/material.dart';

Widget coloredLogo(double logoSize) {
  return new Image.asset(
    "assets/images/logo.png",
    width: logoSize,
    height: logoSize,
  );
}

Widget lightLogo(double logoSize) {
  return new Image.asset(
    "assets/images/dark_logo.png",
    width: logoSize,
    height: logoSize,
  );
}

Widget strockLogo(double logoSize) {
  return new Image.asset(
    "assets/images/logo.gif",
    width: logoSize,
    height: logoSize,
  );
}
Widget strockLogoMotionLight(double logoSize) {
  return new Image.asset(
    "assets/images/logoLight.gif",
    width: logoSize,
    height: logoSize,
  );
}
