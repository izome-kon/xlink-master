import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Helper/api_helper.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/utils/images.dart';

import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool secure1 = true;
  bool secure2 = true;
  bool secure3 = true;
  bool error1 = false;
  String error1Message = "";
  bool error2 = false;
  String error2Message = "";

  TextEditingController currController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confNewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'تغيير كلمة المرور',
            style: Theme.of(context).textTheme.headline5.copyWith(
                fontSize: 20, fontFamily: arabicFontMedium, color: whiteColor),
          )),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          resetPassword,
          SizedBox(
            height: 30,
          ),
          ListTile(
            title: TextField(
              controller: currController,
              textDirection: TextDirection.ltr,
              obscureText: secure1,
              onChanged: (_) {
                setState(() {
                  error1 = false;
                  error1Message = null;
                });
              },
              style: TextStyle(color: accentColor),
              decoration: InputDecoration(
                  fillColor: whiteColor,
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: primaryColor.withOpacity(secure1 ? 0.3 : 1),
                      ),
                      onPressed: () {
                        setState(() {
                          secure1 = !secure1;
                        });
                      }),
                  errorText: error1 ? error1Message : null,
                  errorStyle: TextStyle(fontSize: 12, color: Colors.redAccent),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  labelText: "كلمة المرور الحالية",
                  contentPadding: EdgeInsets.all(10.0),
                  hintStyle: TextStyle(
                      color: accentColor.withOpacity(0.7), fontSize: 15)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: TextField(
              controller: newController,
              textDirection: TextDirection.ltr,
              obscureText: secure2,
              style: TextStyle(color: accentColor),
              onChanged: (_) {
                if (error2) {
                  if (confNewController.text == newController.text &&
                      newController.text.length >= 6)
                    setState(() {
                      error2 = false;
                    });
                }
              },
              decoration: InputDecoration(
                  errorText: error2 ? "" : null,
                  errorStyle: TextStyle(fontSize: 0, color: Colors.redAccent),
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: primaryColor.withOpacity(secure2 ? 0.3 : 1),
                      ),
                      onPressed: () {
                        setState(() {
                          secure2 = !secure2;
                        });
                      }),
                  fillColor: whiteColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  labelText: "كلمة المرور الجديدة",
                  contentPadding: EdgeInsets.all(10.0),
                  hintStyle: TextStyle(
                      color: accentColor.withOpacity(0.7), fontSize: 15)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: TextField(
              onChanged: (_) {
                if (error2) {
                  if (confNewController.text == newController.text)
                    setState(() {
                      error2 = false;
                    });
                }
              },
              controller: confNewController,
              obscureText: secure3,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: accentColor),
              decoration: InputDecoration(
                  errorText: error2 ? error2Message : null,
                  errorStyle: TextStyle(fontSize: 12, color: Colors.redAccent),
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: primaryColor.withOpacity(secure3 ? 0.3 : 1),
                      ),
                      onPressed: () {
                        setState(() {
                          secure3 = !secure3;
                        });
                      }),
                  fillColor: whiteColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  labelText: "تأكيد كلمة المرور",
                  contentPadding: EdgeInsets.all(10.0),
                  hintStyle: TextStyle(
                      color: accentColor.withOpacity(0.7), fontSize: 15)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Consumer<GlobalProvider>(
            builder: (context, prov, child) {
              return ListTile(
                title: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 45,
                  child: RaisedButton(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "تقديم",
                      style: TextStyle(color: whiteColor),
                    ),
                    onPressed: () {
                      onSubmit(prov.user.userId);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onSubmit(int userId) {
    if (newController.text != confNewController.text) {
      setState(() {
        error2 = true;
        error2Message = "يرجى التأكد من تطابق كلمة المرور";
      });
    } else if (newController.text.length < 6) {
      setState(() {
        error2 = true;
        error2Message = "يجب أن لا تقل كلمة المرور عن 6 احرف";
      });
    } else if (currController.text.length != 0) {
      AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: 'جاري تحديث البيانات',
        desc: "برجاء الإنتظار..",
        customHeader: CircularProgressIndicator(),
      )..show();
      ApiHelper()
          .changePassword(currController.text, newController.text, userId)
          .then((value) async {
        Navigator.pop(context);
        if (value.data['status'] == 200) {
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
                Navigator.popUntil(
                    context, ModalRoute.withName('ResturantHome'));
              },
              btnOkText: 'حسناً')
            ..show();
        } else if (value.data['status'] == 405) {
          setState(() {
            error1 = true;
            error1Message = value.data['message'];
          });
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
        }
      });
    }
  }
}
