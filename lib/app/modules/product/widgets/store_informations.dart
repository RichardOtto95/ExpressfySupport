import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/core/models/seller_model.dart';
import 'package:delivery_support/app/modules/product/widgets/question.dart';
import 'package:delivery_support/app/modules/product/widgets/see_all_button.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../product_store.dart';

class StoreInformations extends StatelessWidget {
  final String sellerId;
  final String adsId;
  final ProductStore store;

  const StoreInformations({
    Key? key,
    required this.sellerId,
    required this.adsId,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: grey.withOpacity(.2))),
      ),
      padding: EdgeInsets.only(bottom: wXD(29, context)),
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sellerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              Seller sellerModel = Seller.fromDoc(snapshot.data!);
              return Container(
                width: maxWidth(context),
                padding: EdgeInsets.only(
                  top: wXD(27, context),
                  left: wXD(24, context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações da loja',
                      style: textFamily(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: darkGrey,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: wXD(51, context),
                          width: wXD(54, context),
                          color: grey.withOpacity(.3),
                          margin: EdgeInsets.only(right: wXD(9, context)),
                          child: CachedNetworkImage(
                            imageUrl: sellerModel.avatar!,
                            width: wXD(116, context),
                            height: wXD(122, context),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, label, downloadProgress) {
                              print(
                                  'progressIndicatorBuilder downloadprogress: $downloadProgress');
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sellerModel.storeName ?? "Sem nome",
                              style: textFamily(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: totalBlack,
                              ),
                            ),
                            Text(
                              sellerModel.storeCategory ?? "Sem categoria",
                              style: textFamily(
                                height: 1.6,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: veryLightGrey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(10, context)),
                      child: Text(
                        'Descrição',
                        style: textFamily(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: darkGrey,
                        ),
                      ),
                    ),
                    Text(
                      sellerModel.storeDescription ?? "Sem descrição",
                      style: textFamily(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(10, context)),
                      child: Text(
                        'Devolução grátis',
                        style: textFamily(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: darkGrey,
                        ),
                      ),
                    ),
                    Text(
                      sellerModel.returnPolicies ??
                          "Sem políticas de devolução grátis",
                      style: textFamily(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(10, context)),
                      child: Text(
                        'Garantia',
                        style: textFamily(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: darkGrey,
                        ),
                      ),
                    ),
                    Text(
                      sellerModel.warranty ?? "Sem termos de garantia",
                      style: textFamily(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(10, context)),
                      child: Text(
                        'Forma de pagamento',
                        style: textFamily(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: darkGrey,
                        ),
                      ),
                    ),
                    Text(
                      sellerModel.paymentMethod ??
                          "Sem formas de pagamento informadas",
                      style: textFamily(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(21, context)),
                      child: Text(
                        'Perguntas e respostas',
                        style: textFamily(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: darkGrey,
                        ),
                      ),
                    ),
                    // Container(
                    //   height: wXD(52, context),
                    //   width: wXD(332, context),
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: wXD(17, context)),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //         color: primary.withOpacity(.65)),
                    //     borderRadius: BorderRadius.all(Radius.circular(12)),
                    //   ),
                    //   alignment: Alignment.centerLeft,
                    //   child: TextField(
                    //     controller: textController,
                    //     onChanged: (val) => question = val,
                    //     decoration: InputDecoration.collapsed(
                    //       hintText: 'Faça sua pergunta...',
                    //       hintStyle: textFamily(
                    //           fontSize: 14,
                    //           color: darkGrey.withOpacity(.55),
                    //           fontWeight: FontWeight.w500),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: wXD(13, context)),
                    // SideButton(
                    //   onTap: () async {
                    //     await store.toAsk(question, adsId, context);
                    //     textController.clear();
                    //   },
                    //   title: 'Enviar',
                    //   width: wXD(85, context),
                    // ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("ads")
                          .doc(adsId)
                          .collection("questions")
                          .orderBy("created_at", descending: true)
                          .limit(5)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: wXD(12, context)),
                              child: Text(
                                'Mais recentes',
                                style: textFamily(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: darkGrey,
                                ),
                              ),
                            ),
                            ...snapshot.data!.docs
                                .map((questionDoc) => Question(
                                      answeredAt: questionDoc['answered_at'],
                                      question: questionDoc['question'],
                                      answer: questionDoc['answer'],
                                    ))
                                .toList(),
                            SizedBox(height: wXD(13, context)),
                            snapshot.data!.docs.length > 5
                                ? SeeAllButton(
                                    title: 'Ver todas as perguntas',
                                    onTap: () => Modular.to.pushNamed(
                                        '/product/questions',
                                        arguments: adsId))
                                : Container(),
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
