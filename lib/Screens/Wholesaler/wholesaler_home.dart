import 'package:beda3a/Provider/global_provider.dart';
import 'package:beda3a/Widgets/my_appbar.dart';
import 'package:beda3a/Widgets/wholesaler_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/theme.dart';

class WholesalerHome extends StatefulWidget {
  WholesalerHome({Key key}) : super(key: key);

  @override
  _WholesalerHomeState createState() => _WholesalerHomeState();
}

class _WholesalerHomeState extends State<WholesalerHome> {
  RefreshController controller = RefreshController();
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, prov, child) {
        return Scaffold(
            appBar: MyAppBar(
              type: AppBarType.WHOLESALER,
            ),
            body: SmartRefresher(
                physics: BouncingScrollPhysics(),
                controller: controller,
                header: BezierCircleHeader(
                  rectHeight: 30,
                  bezierColor: primaryColor,
                  enableChildOverflow: true,
                ),
                primary: true,
                onRefresh: () async {
                  await prov.userRefresh().then((_) {
                    controller.refreshCompleted();
                    print(prov.products[0].confirmed);
                  });
                },
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: prov.products.length + 1,
                    itemBuilder: (context, index) {
                      if (index == prov.products.length)
                        return SizedBox(
                          height: 80,
                        );
                      return WholesalerProductCard(prov.products[index]);
                    })));
      },
    );
  }
}
