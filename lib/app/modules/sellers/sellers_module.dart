import 'package:delivery_support/app/modules/sellers/sellers_store.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'sellers_page.dart';

class SellersModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SellersStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const SellersPage()),
  ];

  @override
  Widget get view => const SellersPage();
}
