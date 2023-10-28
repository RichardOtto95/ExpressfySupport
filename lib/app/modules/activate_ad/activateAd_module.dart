// ignore: file_names
import 'package:delivery_support/app/modules/activate_ad/activateAd_Page.dart';
import 'package:delivery_support/app/modules/activate_ad/activateAd_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// ignore: use_key_in_widget_constructors
class ActivateAdModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ActivateAdStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ActivateAdPage()),
  ];

  @override
  Widget get view => const ActivateAdPage();
}
