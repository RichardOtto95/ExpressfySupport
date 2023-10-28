import 'package:delivery_support/app/modules/main/main_module.dart';
import 'package:delivery_support/app/modules/sellerOrders/sellerOrders_module.dart';
import 'package:delivery_support/app/modules/sellers/widgets/add_edit_seller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../modules/advertisement/advertisement_module.dart';
import '../../../modules/customers/widgets/create_coupon.dart';
import '../../../modules/product/product_module.dart';
import '../../../modules/support/widgets/chat.dart';
import 'root_page.dart';
import 'root_store.dart';

class RootModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RootStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => RootPage()),
    ModuleRoute("/main", module: MainModule()),
    ModuleRoute("/advertisement", module: AdvertisementModule()),
    ModuleRoute("/seller-orders", module: SellerOrdersModule()),
    ModuleRoute('/product', module: ProductModule()),
    ChildRoute(
      '/chat',
      child: (_, args) => Chat(
        receiverCollection: args.data["receiverCollection"],
        receiverId: args.data["receiverId"],
        messageId: args.data["messageId"] ?? "",
      ),
    ),
    ChildRoute("/add-seller",
        child: (context, args) => AddEditSeller(editing: args.data)),
    ChildRoute("/create-coupon", child: (context, args) => CreateCoupon()),
  ];
}
