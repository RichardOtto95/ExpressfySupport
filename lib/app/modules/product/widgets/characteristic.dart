import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class Characteristic extends StatelessWidget {
  final String title, data;
  Characteristic({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: wXD(15, context)),
        child: RichText(
          text: TextSpan(
            style: textFamily(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: grey,
            ),
            children: [
              TextSpan(text: '$title: '),
              TextSpan(
                text: data,
                style: textFamily(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: totalBlack,
                ),
              ),
            ],
          ),
        )

        // Wrap(
        //   children: [
        //     Text(
        //       '$title: ',
        //       style: textFamily(
        //         fontSize: 13,
        //         fontWeight: FontWeight.w500,
        //         color: grey,
        //       ),
        //     ),
        //     Text(
        //       data,
        //       style: textFamily(
        //         fontSize: 13,
        //         fontWeight: FontWeight.w500,
        //         color: totalBlack,
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
