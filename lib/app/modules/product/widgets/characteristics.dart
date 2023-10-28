import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class Characteristics extends StatelessWidget {
  final AdsModel model;
  const Characteristics({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: grey.withOpacity(.2)))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: wXD(24, context), right: 24),
            width: maxWidth(context),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: wXD(20, context)),
                  child: Text(
                    'Detalhes do produto',
                    style: textFamily(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: totalBlack,
                    ),
                  ),
                ),
                Text(
                  model.description,
                  style: textFamily(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: totalBlack,
                  ),
                ),
                // Characteristic(title: 'Tamanho da tela', data: '6.5'),
                // Characteristic(title: 'Memória interna', data: '64 GB'),
                // Characteristic(
                //     title: 'Câmera frontal ou principal', data: '8 Mpx'),
                // Characteristic(
                //     title: 'Câmera traseira principal', data: '48 Mpx'),
                // Characteristic(title: 'Desbloqueio', data: 'Impressão digital'),
              ],
            ),
          ),
          // SeeAllButton(
          //   title: 'Ver todas as caracteristicas',
          //   onTap: () => Modular.to.pushNamed('/product/characteristics'),
          // ),
          SizedBox(height: wXD(30, context)),
        ],
      ),
    );
  }
}
