import 'package:beda3a/Provider/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:zendesk/zendesk.dart';

class Chat {
  static final Zendesk zendesk = Zendesk();
  static var zendeskAccountKey = 'DOVOXBcJ2at6EX5SHDmyqq0U9QrS9Mvc';
  static Future<void> initZendesk(context) async {
    GlobalProvider prov = Provider.of<GlobalProvider>(context, listen: false);
    zendesk
        .init(zendeskAccountKey,
            department: prov.user.roleId == 3
                ? "مطاعم"
                : prov.user.roleId == 4
                    ? "تجار"
                    : prov.user.roleId == 5 ? "التوصيل" : "عام",
            appName: 'Beda3a - بضاعة')
        .then((r) {
      // print('init finished');
    }).catchError((e) {
      // print('failed with error $e');
    });
  }

  static Future<void> initZendeskGuast() async {
    zendesk
        .init(zendeskAccountKey, department: "زائر", appName: 'Beda3a - بضاعة')
        .then((r) {
      // print('init finished');
    }).catchError((e) {
      // print('failed with error $e');
    });
  }

  static startChat() async {
    zendesk.startChat().then((r) {
      // print('startChat finished');
    }).catchError((e) {
      // print('error $e');
    });
  }
}
