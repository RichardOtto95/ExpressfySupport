import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
// import '../sellerOrders_store.dart';

class OrdersAppBar extends StatelessWidget {
  final Function(int value) onTap;
  // final SellerOrdersStore store = Modular.get();

  OrdersAppBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).viewPadding.top + wXD(70, context),
      width: maxWidth(context),
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
        color: white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 3),
            color: Color(0x30000000),
          ),
        ],
      ),
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Pedidos',
              style: textFamily(
                fontSize: 20,
                color: darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: wXD(10, context)),
            Container(
              width: maxWidth(context),
              margin: EdgeInsets.only(left: wXD(30, context)),
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                  indicatorColor: primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: const EdgeInsets.symmetric(vertical: 8),
                  labelColor: primary,
                  labelStyle: textFamily(fontWeight: FontWeight.bold),
                  unselectedLabelColor: darkGrey,
                  indicatorWeight: 3,
                  onTap: (value) {
                    if (kDebugMode) {
                      print('value value: $value');
                    }
                    onTap(value);
                  },
                  tabs: const [
                    Text('Em andamento'),
                    Text('Concluídos'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
