import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Screens/Resturant/resturant_main.dart';
import 'package:beda3a/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class Notifcations extends StatefulWidget {
  @override
  _NotifcationsState createState() => _NotifcationsState();
}

class _NotifcationsState extends State<Notifcations> {
  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    await Jiffy.locale('ar').then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "الإشعارات",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(fontFamily: arabicFontMedium, color: primaryColor),
              ),
            ),
            Consumer<GlobalProvider>(
              builder: (context, not, child) {
                return not.notifications.notifcation.length == 0
                    ? Text("لا يوجد إشعارات")
                    : Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: not.notifications.notifcation.length,
                            addAutomaticKeepAlives: true,
                            addRepaintBoundaries: true,
                            physics: BouncingScrollPhysics(),
                            addSemanticIndexes: true,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        not.notifications.notifcation[index]
                                            .title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .apply(
                                                fontSizeFactor: 1.2,
                                                color: accentColor,
                                                fontFamily: arabicFontMedium),
                                      ),
                                      subtitle: Text(
                                        not.notifications.notifcation[index]
                                            .message,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .apply(
                                                color: Colors.black,
                                                fontFamily: arabicFontMedium),
                                      ),
                                    ),
                                    Text(
                                      Jiffy(
                                        not.notifications.notifcation[index]
                                            .createdAt,
                                      ).fromNow(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .apply(
                                            fontFamily: arabicFontMedium,
                                          ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}



class OpenNotification extends StatefulWidget {
  @override
  _OpenNotificationState createState() => _OpenNotificationState();
}

class _OpenNotificationState extends State<OpenNotification> {
  @override
  void initState() {
    Navigator.push(context,MaterialPageRoute(builder:(context) =>ResturantMain()) );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

