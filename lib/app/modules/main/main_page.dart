import 'package:delivery_support/app/modules/customers/customers_module.dart';
import 'package:delivery_support/app/modules/sellers/sellers_module.dart';
import 'package:delivery_support/app/modules/support/support_module.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import '../../shared/utilities.dart';
import '../../shared/widgets/custom_nav_bar.dart';
import '../activate_ad/activateAd_module.dart';
import '../allOrders/allOrders_module.dart';

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key? key, this.title = 'MainPage'}) : super(key: key);
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final MainStore store = Modular.get();

  @override
  void initState() {
    store.saveTokenId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (kDebugMode) {
          print('WillPopScope');
          // print('Modular.to.path ${Modular.to.path}');
          print('page index ${store.page}');
        }
        if(store.page == 2){
          return true;
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Observer(builder: (context) {
              return SizedBox(
                height: maxHeight(context),
                width: maxWidth(context),
                child: PageView(
                  physics: store.paginateEnable
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  controller: store.pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SupportModule(),
                    SellersModule(),
                    CustomersModule(),
                    ActivateAdModule(),
                    AllOrdersModule(),
                  ],
                  onPageChanged: (value) {
                    // print('value: $value');
                    store.page = value;
                    store.setVisibleNav(true);
                  },
                ),
              );
            }),
            Observer(
              builder: (context) {
                return AnimatedPositioned(
                  duration: const Duration(seconds: 2),
                  curve: Curves.bounceOut,
                  bottom: store.visibleNav ? 0 : wXD(-85, context),
                  child: CustomNavBar(),
                );
              },
            ),
            // Observer(
            //   builder: (context) {
            //     return AnimatedPositioned(
            //       duration: Duration(seconds: 1),
            //       curve: Curves.bounceOut,
            //       bottom:
            //           store.visibleNav ? wXD(42, context) : wXD(-68, context),
            //       child: Observer(
            //         builder: (context) {
            //           // print('page: ${store.page}');
            //           return FloatingCircleButton(
            //             onTap: () {
            //               print(store.page);
            //               store.setPage(2);
            //             },
            //             iconColor: store.page == 2 ? primary : white,
            //           );
            //         },
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
