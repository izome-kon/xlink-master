import 'package:beda3a/Shared/chat.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectUs extends StatefulWidget {
  ConnectUs({Key key}) : super(key: key);

  @override
  _ConnectUsState createState() => _ConnectUsState();
}

class _ConnectUsState extends State<ConnectUs> {
  @override
  void initState() {
    Chat.initZendesk(context).then((_) {
      Chat.initZendeskGuast();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'تواصل معنا',
            style: TextStyle(
              fontFamily: arabicFontMedium,
              color: whiteColor,
              fontSize: 20,
            ),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/customer-service.png',
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'تواصل معنا الآن !',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontFamily: arabicFontMedium),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'إذا كان لديك أي استفسار أو تواجه مشكلة فنسعد بتواصلك معنا على مدار 24 ساعة',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Chat.startChat();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.chat,
                  size: 23,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'المحادثة المباشرة',
                  style: TextStyle(color: accentColor, fontSize: 18),
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: _launchURL,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.phone,
                  size: 23,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'اتصل بنا هاتفياً',
                  style: TextStyle(color: accentColor, fontSize: 18),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'tel: +201553004171';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
