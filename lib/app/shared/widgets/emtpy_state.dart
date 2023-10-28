import 'package:flutter/material.dart';

import '../color_theme.dart';
import '../utilities.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? asset;
  const EmptyState({Key? key, required this.title, this.asset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxHeight(context),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            asset ?? './assets/img/emptyState.png',
            width: wXD(200, context),
            height: wXD(160, context),
            alignment: Alignment.center,
          ),
          Text(
            title,
            style: textFamily(
              fontSize: 20,
              color: primary,
            ),
          )
        ],
      ),
    );
  }
}
