import 'dart:ui';

import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class ConfirmPopup extends StatelessWidget {
  final String text;
  final void Function() onConfirm, onCancel;
  final double? height;
  const ConfirmPopup({
    Key? key,
    required this.text,
    required this.onConfirm,
    required this.onCancel,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: GestureDetector(
        onTap: onCancel,
        child: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          color: totalBlack.withOpacity(.6),
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80),
              topRight: Radius.circular(80),
            ),
            child: Container(
              height: height ?? wXD(136, context),
              width: wXD(327, context),
              padding: EdgeInsets.all(wXD(24, context)),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
                boxShadow: [BoxShadow(blurRadius: 18, color: totalBlack)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: textFamily(fontSize: 17),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlackButton(text: 'Não', onTap: onCancel),
                      SizedBox(width: wXD(14, context)),
                      BlackButton(text: 'Sim', onTap: onConfirm),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlackButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final double width;
  const BlackButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.width = 82,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: wXD(47, context),
          width: wXD(width, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: totalBlack,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textFamily(color: primary, fontSize: 17),
          )),
    );
  }
}
