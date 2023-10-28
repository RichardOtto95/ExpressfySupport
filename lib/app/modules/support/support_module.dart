// ignore: implementation_imports
import 'package:delivery_support/app/modules/support/support_Page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'support_store.dart';
import 'widgets/chat.dart';

class SupportModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SupportStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const SupportPage()),
    ChildRoute(
      '/chat',
      child: (_, args) => Chat(
        receiverCollection: args.data["receiverCollection"],
        receiverId: args.data["receiverId"],
        messageId: args.data["messageId"] ?? "",
      ),
    ),
  ];

  @override
  Widget get view => const SupportPage();
}
