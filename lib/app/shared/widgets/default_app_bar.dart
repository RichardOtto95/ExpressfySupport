import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../color_theme.dart';
import '../utilities.dart';

class DefaultAppBar extends StatelessWidget {
  final String title;
  final bool noPop;
  final void Function()? onPop;
  const DefaultAppBar(this.title, {Key? key, this.onPop, this.noPop = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(white),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: maxWidth(context),
            height: viewPaddingTop(context) + wXD(40, context),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48)),
              color: white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Color(0x30000000),
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          noPop
              ? Container()
              : Positioned(
                  bottom: 0,
                  left: wXD(20, context),
                  child: InkWell(
                    onTap: () {
                      if (onPop != null) {
                        onPop!();
                      } else {
                        Modular.to.pop();
                      }
                    },
                    child: Container(
                      height: wXD(36, context),
                      width: wXD(48, context),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "./assets/svg/arrow_backward.svg",
                        height: wXD(11, context),
                        width: wXD(20, context),
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: wXD(9, context),
            child: Text(
              title,
              style: const TextStyle(
                color: textBlack,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
