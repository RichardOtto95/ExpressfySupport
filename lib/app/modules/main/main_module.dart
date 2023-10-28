import 'package:delivery_support/app/modules/main/main_Page.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MainStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MainPage()),
  ];
}
