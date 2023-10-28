import 'package:delivery_support/app/modules/allOrders/allOrders_Page.dart';
import 'package:delivery_support/app/modules/allOrders/allOrders_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AllOrdersModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AllOrdersStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const AllOrdersPage()),
  ];

  @override
  Widget get view => const AllOrdersPage();
}