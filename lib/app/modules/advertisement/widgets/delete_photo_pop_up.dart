import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class DeletePhotoPupUp extends StatelessWidget {
  DeletePhotoPupUp({Key? key}) : super(key: key);
  final AdvertisementStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(120, context),
      width: maxWidth(context),
      decoration: const BoxDecoration(
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
        top: wXD(24, context),
        bottom: wXD(24, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              store.removeImage();
              store.setDeleteImage(false);
              store.setRemovingEditingAd(false);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: wXD(25, context),
                  color: darkGrey,
                ),
                SizedBox(width: wXD(5, context)),
                Text(
                  'Excluir',
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
              store.setDeleteImage(false);
              store.setRemovingEditingAd(false);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
