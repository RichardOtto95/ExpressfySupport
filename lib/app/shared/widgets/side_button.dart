import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Widget? child;
  final bool isWhite;
  final void Function() onTap;
  final String title;

  const SideButton({
    Key? key,
    this.width,
    required this.onTap,
    this.title = '',
    this.height,
    this.child,
    this.isWhite = false,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isWhite ? Alignment.centerLeft : Alignment.centerRight,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? wXD(81, context),
          height: height ?? wXD(44, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(isWhite ? 0 : 50),
              right: Radius.circular(isWhite ? 50 : 0),
            ),
            border: Border.all(
              color: isWhite ? darkGrey.withOpacity(.25) : totalBlack,
            ),
            color: isWhite ? white : darkBlue,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 3),
                color: isWhite ? Color(0x80000000) : Color(0x30000000),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: child == null
              ? Text(
                  title,
                  style: textFamily(
                    color: primary,
                    fontSize: fontSize ?? 18,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
