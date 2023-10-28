import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/modules/product/widgets/see_all_button.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../shared/stars_load_circular.dart';
import '../product_store.dart';

class Opinions extends StatelessWidget {
  final ProductStore store = Modular.get();
  final AdsModel model;

  Opinions({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(context) {
    int _page = 0;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("ads")
            .doc(model.id)
            .collection("ratings")
            .orderBy("created_at", descending: true)
            .limit(15)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container();
          }
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            store.getRatings(_page, snapshot.data!.docs);
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: wXD(23, context), left: wXD(24, context)),
                child: Text(
                  'Opiniôes sobre o produto',
                  style: textFamily(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: darkGrey,
                  ),
                ),
              ),
              Row(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                    future: model.getRating(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: wXD(23, context), left: wXD(23, context)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '0.0',
                                style: textFamily(
                                  fontSize: 31,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                              SizedBox(width: wXD(20, context)),
                              Column(
                                children: [
                                  StarsLoadCircular(size: wXD(20, context)),
                                  Text(
                                    'Média entre --- opiniões',
                                    style: textFamily(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      double rating = snapshot.data!['rating'].toDouble();
                      // print("rating: $rating");
                      return Padding(
                        padding: EdgeInsets.only(
                            top: wXD(23, context), left: wXD(23, context)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              rating.toString().substring(0, 3),
                              style: textFamily(
                                fontSize: 31,
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                            SizedBox(width: wXD(20, context)),
                            Column(
                              children: [
                                RatingBar(
                                  initialRating: rating,
                                  ignoreGestures: true,
                                  onRatingUpdate: (value) {},
                                  glowColor: primary.withOpacity(.4),
                                  unratedColor: primary.withOpacity(.4),
                                  allowHalfRating: true,
                                  itemSize: wXD(20, context),
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star_rounded,
                                        color: primary),
                                    empty: const Icon(
                                        Icons.star_outline_rounded,
                                        color: primary),
                                    half: const Icon(Icons.star_half_rounded,
                                        color: primary),
                                  ),
                                ),
                                Text(
                                  snapshot.data!['length'] == 1
                                      ? "Média entre ${snapshot.data!['length']} opinião"
                                      : "Média entre ${snapshot.data!['length']} opiniões",
                                  style: textFamily(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: wXD(13, context)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: darkGrey.withOpacity(.2)))),
                width: maxWidth(context),
                child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                    onTap: (page) {
                      _page = page;
                      store.getRatings(page, snapshot.data!.docs);
                    },
                    indicatorColor: primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.symmetric(vertical: 8),
                    labelColor: primary,
                    labelStyle: textFamily(fontWeight: FontWeight.w500),
                    unselectedLabelColor: darkGrey,
                    indicatorWeight: 3,
                    tabs: [Text('Todas'), Text('Positivas'), Text('Negativas')],
                  ),
                ),
              ),
              Observer(
                builder: (context) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: store.ratings.isEmpty
                            ? [
                                Icon(Icons.star_border_rounded,
                                    size: wXD(200, context), color: totalBlack),
                                Observer(
                                  builder: (context) {
                                    return Text(
                                        _page == 1
                                            ? "Sem avaliações positivas"
                                            : "Sem avaliações negativas",
                                        style: textFamily());
                                  },
                                ),
                              ]
                            : store.ratings
                                .map((e) => Opinion(
                                      productOpnion: e['product_opnion'],
                                      rating: e['product_rating'].toDouble(),
                                    ))
                                .toList()),
                  );
                },
              ),
              SizedBox(height: wXD(18, context)),
              snapshot.data!.docs.length > 15
                  ? SeeAllButton(
                      title: 'Ver todas as opiniões',
                      onTap: () => Modular.to
                          .pushNamed('/product/ratings', arguments: model.id))
                  : Container(),
              SizedBox(height: wXD(24, context)),
              Padding(
                padding: EdgeInsets.only(
                    left: wXD(12, context), bottom: wXD(17, context)),
                child: Row(
                  children: [
                    Text(
                      'Anúncio #${model.id.substring(0, 10).toUpperCase()}',
                      style: textFamily(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: grey,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: wXD(18, context)),
                      height: wXD(12, context),
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(color: darkGrey.withOpacity(.2)))),
                    ),
                    // InkWell(
                    //   onTap: () => Modular.to.pushNamed(
                    //       "/product/report-product",
                    //       arguments: model.id),
                    //   child: Text(
                    //     'Denunciar',
                    //     style: textFamily(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       color: blue,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class Opinion extends StatelessWidget {
  final double rating;
  final String? productOpnion;

  Opinion({
    Key? key,
    required this.rating,
    required this.productOpnion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: wXD(126, context),
      width: maxWidth(context),
      padding: EdgeInsets.fromLTRB(
        wXD(24, context),
        wXD(23, context),
        wXD(22, context),
        wXD(16, context),
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: darkGrey.withOpacity(.2)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBar(
            initialRating: rating,
            ignoreGestures: true,
            onRatingUpdate: (value) {},
            glowColor: primary.withOpacity(.4),
            unratedColor: primary.withOpacity(.4),
            allowHalfRating: true,
            itemSize: wXD(16, context),
            ratingWidget: RatingWidget(
              full: Icon(Icons.star_rounded, color: primary),
              empty: Icon(Icons.star_outline_rounded, color: primary),
              half: Icon(Icons.star_half_rounded, color: primary),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: wXD(21, context), bottom: wXD(6, context)),
            child: Text(
              getRatingString(),
              style: textFamily(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: darkGrey,
              ),
            ),
          ),
          productOpnion != null
              ? Text(
                  productOpnion!,
                  style: textFamily(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: grey,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  String getRatingString() {
    if (rating == 5) {
      return "Ótimo";
    } else if (rating >= 4) {
      return "Bom";
    } else if (rating >= 3) {
      return "Regular";
    } else if (rating >= 2) {
      return "Ruim";
    } else if (rating >= 1) {
      return "Péssimo";
    }
    return "Erro";
  }
}
