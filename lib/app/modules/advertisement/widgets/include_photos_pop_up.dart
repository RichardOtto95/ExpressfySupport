import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class IncludePhotosPopUp extends StatelessWidget {
  IncludePhotosPopUp({Key? key}) : super(key: key);
  final AdvertisementStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(161, context),
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(55)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, -5),
            color: Color(0x90000000),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: wXD(38, context),
        top: wXD(36, context),
        bottom: wXD(22, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => store.pickImage(),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: wXD(25, context),
                  color: darkGrey,
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Tirar foto',
                  style: textFamily(
                    fontSize: 15,
                    color: darkGrey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => store.uploadImage(),
            child: Row(
              children: [
                Icon(
                  Icons.picture_in_picture_rounded,
                  size: wXD(25, context),
                  color: darkGrey,
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Escolher existente...',
                  style: textFamily(
                    fontSize: 15,
                    color: darkGrey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              store.settakePicture(false);
            },
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  size: wXD(25, context),
                  color: darkGrey,
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Cancelar',
                  style: textFamily(
                    fontSize: 15,
                    color: darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
