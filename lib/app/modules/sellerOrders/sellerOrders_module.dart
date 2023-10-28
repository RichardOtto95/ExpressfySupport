import 'package:delivery_support/app/modules/sellerOrders/sellerOrders_page.dart';
import 'package:delivery_support/app/modules/sellerOrders/sellerOrders_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SellerOrdersModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SellerOrdersStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SellerOrdersPage(
      sellerId: args.data,
    )),
  ];
}
