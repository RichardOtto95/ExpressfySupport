import 'dart:ui';

import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class CongratulationsPopup extends StatelessWidget {
  final String text;
  final String subText;
  final void Function() onNewAd, onBack;
  final double? height;
  const CongratulationsPopup({
    Key? key,
    required this.text,
    required this.subText,
    required this.onNewAd,
    required this.onBack,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: maxHeight(context),
      width: maxWidth(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: GestureDetector(
          onTap: onBack,
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
                height: wXD(155, context),
                width: wXD(327, context),
                padding: EdgeInsets.only(
                    bottom: wXD(19, context), top: wXD(11, context)),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 18, color: totalBlack)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: textFamily(
                        fontSize: 17,
                        color: totalBlack,
                      ),
                    ),
                    SizedBox(height: wXD(11, context)),
                    Text(
                      subText,
                      textAlign: TextAlign.center,
                      style: textFamily(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: totalBlack,
                      ),
                    ),
                    SizedBox(height: wXD(9, context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlackButton(text: 'Voltar', onTap: onBack),
                        SizedBox(width: wXD(16, context)),
                        BlackButton(text: 'Novo anúncio', onTap: onNewAd),
                        SizedBox(width: wXD(20, context)),
                      ],
                    )
                  ],
                ),
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
  const BlackButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: wXD(47, context),
          // width: wXD(82, context),
          padding: EdgeInsets.symmetric(horizontal: wXD(20, context)),
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
