import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import 'root_store.dart';

class RootPage extends StatelessWidget {
  final RootStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    Modular.to.pushReplacementNamed("/main/");
    return Container();
  }
}
