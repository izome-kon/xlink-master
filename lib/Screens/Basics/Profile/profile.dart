import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Basics/Profile/edit_profile.dart';
import 'package:beda3a/Screens/Basics/Profile/profile_image.dart';
import 'package:beda3a/Screens/Basics/Profile/reset_password.dart';
import 'package:beda3a/utils/images.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:beda3a/Shared/shared_pref.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<GlobalProvider>(
      builder: (context, prov, child) {
        return SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.301,
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
                        child: Hero(
                          tag: "profileImage",
                          child: InkWell(
                            onTap: () {
                              AwesomeDialog(
                                  context: context,
                                dialogType:DialogType.NO_HEADER,

                                  body: Hero(
                                    tag: "profileImage",
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${prov.usersImageProflilUrl}/${prov.user.avatar}',
                                    ),
                                  ))
                                ..show();
                            },
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
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    prov.user.userName,
                    style: TextStyle(fontSize: 25, color: whiteColor),
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                  title: Text(
                    'معلومات الحساب',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(color: primaryColor),
                  ),
                  subtitle: Text(
                    'التعديل على معلوماتك ( الاسم ، رقم الهاتف ، الخ..)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .apply(color: Colors.black45),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => EditProfile()));
                  }),
            ),
            Card(
              child: ListTile(
                  leading: Icon(
                    Icons.vpn_key,
                    color: primaryColor,
                  ),
                  title: Text(
                    'تغيير كلمة المرور',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(color: primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ResetPassword()));
                  }),
            ),
            prov.user.roleId == 3
                ? Card(
                    child: ListTile(
                        leading: Icon(
                          Icons.monetization_on,
                          color: primaryColor,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الفلوس اللي عليك',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .apply(color: primaryColor),
                            ),
                            Text(
                                '${prov.user.wallet.required + prov.user.wallet.paidUp} ج.م'),
                          ],
                        ),
                        onTap: () {/* react to the tile being tapped */}),
                  )
                : Container(),
            Card(
              child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: primaryColor,
                  ),
                  title: Text(
                    'تسجيل الخروج',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(color: primaryColor),
                  ),
                  onTap: () {
                    SharedPref.logOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'Login', (route) => false);
                  }),
            ),
          ]),
        );
      },
    ));
  }
}
