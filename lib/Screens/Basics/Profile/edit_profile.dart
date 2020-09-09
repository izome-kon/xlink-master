import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Models/resturant_model.dart';
import 'package:beda3a/Models/user_model.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'package:beda3a/utils/theme.dart';

class EditProfile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<EditProfile> {
  bool enabel;
  File _imageFile;
  File _croppedImage;
  Future<void> _pickImage() async {
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
                hideBottomControls: true,
                toolbarWidgetColor: whiteColor,
                toolbarColor: primaryColor),
            sourcePath: _imageFile.path,
            aspectRatio: CropAspectRatio(ratioX: 100, ratioY: 120),
            cropStyle: CropStyle.circle)
        .then((value) {
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
          snappings: [0.9, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          (() {
            if (_croppedImage == null) Navigator.pop(context);
          }());
          return Material(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 220,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: FileImage(_croppedImage),
                      radius: 100,
                    ),
                    CircleAvatar(
                        backgroundColor: primaryColor,
                        child: IconButton(
                            color: whiteColor,
                            icon: Icon(Icons.crop),
                            onPressed: _cropImage))
                  ],
                ),
                Consumer<GlobalProvider>(
                  builder: (context, prov, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 55,
                      child: RaisedButton(
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            headerAnimationLoop: false,
                            dismissOnBackKeyPress: false,
                            dismissOnTouchOutside: false,
                            title: 'جاري رفع صورة',
                            desc: "برجاء الإنتظار..",
                            customHeader: CircularProgressIndicator(),
                          )..show();
                          ApiHelper()
                              .uploadImage(
                                  _croppedImage, "users", prov.user.userId)
                              .then((value) {
                            Navigator.of(context).pop();
                            setState(() {
                              prov.setUserImage(value);
                            });
                            Navigator.of(context).pop();
                          });
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

  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _resturantNameFocusNode = FocusNode();

  @override
  void initState() {
    enabel = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalProvider prov = Provider.of<GlobalProvider>(context);
    var resturantController = TextEditingController(
        text: prov.user.resturant != null ? prov.user.resturant.name : '');
    var nameController = TextEditingController(text: prov.user.userName);
    var phoneController =
        TextEditingController(text: prov.user.phone.toString());

    return Scaffold(
        appBar: PreferredSize(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.401,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: primaryColor,
                  backgroundBlendMode: BlendMode.darken,
                  image: DecorationImage(
                      image: AssetImage('assets/images/LogoBG.png'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SafeArea(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: whiteColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AvatarGlow(
                      glowColor: whiteColor,
                      endRadius: 70,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius:
                                50, //Image.asset('assets/images/welcome-page3.png')
                            backgroundImage: CachedNetworkImageProvider(
                              '${prov.usersImageProflilUrl}/${prov.user.avatar}',
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: !enabel
                            ? IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    enabel = true;
                                  });
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.done,
                                      color: accentColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        User newUser = prov.user;
                                        newUser.userName = nameController.text;
                                        newUser.phone =
                                            int.parse(phoneController.text);
                                        if (newUser is Resturant) {
                                          newUser.resturant.name =
                                              resturantController.text;
                                        }

                                        User oldUser = newUser;
                                        update(newUser, oldUser).then((value) {
                                          prov.setUser(value);
                                          SharedPref.setUser(value);
                                        });
                                        enabel = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                      ),
                      Text(
                        prov.user.userName,
                        style: TextStyle(fontSize: 25, color: whiteColor),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.5,
            )),
        body: Consumer<GlobalProvider>(
          builder: (context, prov, child) {
            return SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: enabel,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_phoneFocusNode);
                            },
                            style: enabel
                                ? TextStyle(color: accentColor)
                                : TextStyle(
                                    color: accentColor.withOpacity(0.4)),
                            controller: nameController,
                            decoration: InputDecoration(
                                fillColor: whiteColor,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                labelText: "أسمك",
                                contentPadding: EdgeInsets.all(20.0),
                                hintStyle: TextStyle(
                                    color: accentColor.withOpacity(0.7),
                                    fontSize: 15)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            focusNode: _phoneFocusNode,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_resturantNameFocusNode);
                            },
                            style: enabel
                                ? TextStyle(color: accentColor)
                                : TextStyle(
                                    color: accentColor.withOpacity(0.4)),
                            enabled: enabel,
                            controller: phoneController,
                            decoration: InputDecoration(
                                fillColor: whiteColor,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                labelText: "رقم الهاتف",
                                contentPadding: EdgeInsets.all(20.0),
                                hintStyle: TextStyle(
                                    color: accentColor.withOpacity(0.7),
                                    fontSize: 15)),
                          ),
                        ),
                        prov.user.resturant != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  focusNode: _resturantNameFocusNode,
                                  textInputAction: TextInputAction.done,
                                  style: enabel
                                      ? TextStyle(color: accentColor)
                                      : TextStyle(
                                          color: accentColor.withOpacity(0.4)),
                                  enabled: enabel,
                                  controller: resturantController,
                                  decoration: InputDecoration(
                                      fillColor: whiteColor,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      labelText: "اسم المطعم",
                                      contentPadding: EdgeInsets.all(20.0),
                                      hintStyle: TextStyle(
                                          color: accentColor.withOpacity(0.7),
                                          fontSize: 15)),
                                ),
                              )
                            : Container(),
                      ],
                    ))
              ]),
            );
          },
        ));
  }

  Future<User> update(User newUser, User oldUser) async {
    AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      title: 'جاري تحديث البيانات',
      desc: "برجاء الإنتظار..",
      customHeader: CircularProgressIndicator(),
    )..show();

    await ApiHelper().updateUser(newUser).then((value) {
      Navigator.pop(context);
      if (value == UserUpdateStates.PHONE_ERROR) {
        AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          autoHide: Duration(seconds: 3),
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          title: 'خطأ',
          desc:
              "للأسف حدث خطأ .. تأكد من عدم تسجيل رقم الهاتف لدينا من قبل وحاول مرة أخرى",
        )..show();
        return oldUser;
      } else if (value == UserUpdateStates.DONE) {
        AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            title: 'تم بنجاح',
            desc: "لقد تم تحديث البيانات بنجاح !",
            btnOkOnPress: () {
              Navigator.popUntil(context, ModalRoute.withName('ResturantHome'));
            },
            btnOkText: 'حسناً')
          ..show();
        return newUser;
      } else {
        AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          autoHide: Duration(seconds: 3),
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          title: 'خطأ',
          desc: "للأسف حدث خطأ .. حاول مرة أخرى",
        )..show();
        return oldUser;
      }
    });
    return oldUser;
  }
}
