import 'package:delivery_support/app/modules/customers/customers_Page.dart';
import 'package:delivery_support/app/modules/customers/customers_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomersModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CustomersStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const CustomersPage()),
  ];

  @override
  Widget get view => const CustomersPage();
}
