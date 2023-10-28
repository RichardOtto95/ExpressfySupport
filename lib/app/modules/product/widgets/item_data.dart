import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/modules/product/product_store.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemData extends StatelessWidget {
  final AdsModel model;
  final ProductStore store;
  const ItemData({Key? key, required this.model, required this.store})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      // print(
      //     'Diference: ${wXD(scrollController.offset, context) / wXD(130, context)}');
      // print(
      //     'integer part: ${(wXD(scrollController.offset, context) ~/ wXD(130.56, context)).toInt() + 1}');
      store.setImageIndex(
          (wXD(scrollController.offset, context) ~/ wXD(130.56, context))
                  .toInt() +
              1);
    });
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: wXD(60, context)),
              height: maxWidth(context),
              width: maxWidth(context),
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.only(right: wXD(10, context)),
                physics:
                    const PageScrollPhysics(parent: BouncingScrollPhysics()),
                child: SizedBox(
                  height: maxWidth(context),
                  width: maxWidth(context),
                  child: PageView(
                    children: List.generate(
                      model.images.length,
                      (index) => CachedNetworkImage(
                        imageUrl: model.images[index],
                        height: maxWidth(context),
                        width: maxWidth(context),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, str, value) {
                          // print(value.progress);
                          return Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: value.progress,
                            ),
                          );
                        },
                      ),
                    ),
                    onPageChanged: (page) => store.imageIndex = page + 1,
                  ),
                ),
              ),
            ),
            Container(
              width: maxWidth(context),
              padding: EdgeInsets.symmetric(horizontal: wXD(18.5, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: wXD(300, context),
                            child: Text(
                              model.title,
                              style: textFamily(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: totalBlack,
                              ),
                            ),
                          ),
                          SizedBox(height: wXD(3, context)),
                          Row(
                            children: [
                              SizedBox(width: wXD(6, context)),
                              RatingBar(
                                initialRating: 0,
                                ignoreGestures: true,
                                onRatingUpdate: (value) {},
                                glowColor: primary.withOpacity(.4),
                                unratedColor: primary.withOpacity(.4),
                                allowHalfRating: true,
                                itemSize: wXD(15, context),
                                ratingWidget: RatingWidget(
                                  full: const Icon(Icons.star_rounded,
                                      color: primary),
                                  empty: const Icon(Icons.star_outline_rounded,
                                      color: primary),
                                  half: const Icon(Icons.star_half_rounded,
                                      color: primary),
                                ),
                              ),
                              SizedBox(width: wXD(14, context)),
                              Text(
                                '(${model.ratings})',
                                style: textFamily(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: primary,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          FloatingCircleButton(
                            onTap: () {},
                            size: wXD(29, context),
                            color: white,
                            child: Padding(
                              padding: EdgeInsets.only(top: wXD(2, context)),
                              child: Icon(
                                Icons.favorite,
                                size: wXD(23, context),
                                color: primary,
                              ),
                            ),
                          ),
                          Text(
                            '${model.likeCount}',
                            style: textFamily(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: wXD(22, context)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: wXD(50, context),
                        child: Container(
                          margin: EdgeInsets.only(left: wXD(6, context)),
                          height: wXD(21, context),
                          width: wXD(44, context),
                          decoration: const BoxDecoration(
                              color: veryLightOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13))),
                          alignment: Alignment.center,
                          child: Text(
                            '${store.imageIndex} / ${model.images.length}',
                            style: textFamily(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: maxWidth(context),
                        width: wXD(50, context),
                        alignment: Alignment.bottomRight,
                        child: FloatingCircleButton(
                          onTap: () {
                            store.share();
                          },
                          size: wXD(29, context),
                          color: white,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: wXD(2, context), right: wXD(2, context)),
                            child: Icon(
                              Icons.share_outlined,
                              size: wXD(23, context),
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: wXD(317, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'R\$${formatedCurrency(model.totalPrice)}  ',
                                style: textFamily(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: primary,
                                ),
                              ),
                              model.oldPrice != null
                                  ? model.oldPrice! > model.sellerPrice
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              bottom: wXD(3, context)),
                                          child: Text(
                                            '${getPercentOff()}% OFF',
                                            style: textFamily(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: green,
                                            ),
                                          ),
                                        )
                                      : Container()
                                  : Container(),
                            ],
                          ),
                          // Text(
                          //   'em 10 x R\$ ${formatedCurrency(model.sellerPrice / 10)} sem juros ',
                          //   style: textFamily(
                          //     fontSize: 13,
                          //     fontWeight: FontWeight.w500,
                          //     color: green,
                          //   ),
                          // ),
                          // Option(title: 'Cor', options: ['Preto']),
                          // Option(title: 'Quantidade', options: ['1'], qtd: true),
                          // Option(
                          //   title: 'Armazenamento',
                          //   options: [
                          //     '32 Gb',
                          //     '64 Gb',
                          //     '128 Gb',
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String getPercentOff() {
    int percent = (model.sellerPrice / model.oldPrice! * 100).toInt();
    return percent.toString();
  }
}
