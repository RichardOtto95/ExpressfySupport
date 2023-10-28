import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/core/models/seller_model.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/modules/sellers/widgets/seller_card.dart';
import 'package:delivery_support/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_support/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_support/app/modules/sellers/sellers_store.dart';
import 'package:flutter/material.dart';

import '../../shared/color_theme.dart';
import '../../shared/utilities.dart';
import '../../shared/widgets/floating_circle_button.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({Key? key}) : super(key: key);
  @override
  SellersPageState createState() => SellersPageState();
}

class SellersPageState extends State<SellersPage> {
  final SellersStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final ScrollController scrollController = ScrollController();

  int limit = 20;

  double lastExtent = 0;
  @override
  void initState() {
    scrollController.addListener(() {
      // print("ScrollDirection: ${}");
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 300) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          lastExtent = scrollController.position.maxScrollExtent;
          limit += 15;
          // print("adicionando mais 10");
          // print("scroll: ${scrollController.offset}");
          // print("maxContent: ${scrollController.position.maxScrollExtent}");
          // print("limit: $limit");
        });
      }
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          store.getAddSeller()) {
        store.setAddSeller(false);
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !store.getAddSeller()) {
        store.setAddSeller(true);
        mainStore.setVisibleNav(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: SizedBox(
              height: maxHeight(context),
              width: maxWidth(context),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("sellers")
                    .orderBy("created_at", descending: true)
                    .where("status", whereIn: ["ACTIVE", "PREREGISTERED", "UNDER-ANALYSIS"])
                    .limit(limit)
                    .snapshots(),
                builder: (context, selSnap) {
                  if(selSnap.hasError){
                    if (kDebugMode) {
                      print(selSnap.error);
                    }
                  }
                  if (!selSnap.hasData) {
                    return const CenterLoadCircular();
                  }
                  return Listener(
                    onPointerDown: (event) {
                      mainStore.removeGlobalOverlay();
                    },
                    child: Column(children: [
                      SizedBox(
                          height: viewPaddingTop(context) + wXD(50, context)),
                      ...List.generate(
                        selSnap.data!.docs.length,
                        (index) {
                          // Seller seller =
                          //     Seller.fromDoc(selSnap.data!.docs[index]);
                          return SellerCard(
                              sellerDoc: selSnap.data!.docs[index]);
                        },
                      ),
                      SizedBox(height: wXD(50, context)),
                    ]),
                  );
                },
              ),
            ),
          ),
          Observer(builder: (context) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.ease,
              bottom: wXD(127, context),
              right: store.addSeller ? wXD(17, context) : wXD(-56, context),
              child: FloatingCircleButton(
                onTap: () async
                    //   print("aaaaaaaa");
                    //   OverlayEntry overlayEntry = OverlayEntry(
                    //       builder: (context) => const LoadCircularOverlay());

                    //   Overlay.of(context)?.insert(overlayEntry);

                    //   String sellerId = "HOoCNZsI1hXncWyAebnJ";

                    //   List<AdsModel> adsArray = [
                    //     AdsModel(
                    //       deliveryType: "moto",
                    //       title: ,
                    //       description: ,
                    //       category: "Acessórios e eletrônicos",
                    //       option: "Outros",
                    //       type: "Outras marcas",
                    //       isNew: true,
                    //       sellerPrice: ,
                    //       paused: false,
                    //       status: 'ACTIVE',
                    //       images: [],
                    //       sellerId: sellerId,
                    //       onlineSeller: false,
                    //     ),
                    //     AdsModel(
                    //       deliveryType: "moto",
                    //       title: ,
                    //       description: ,
                    //       category: "Acessórios e eletrônicos",
                    //       option: "Outros",
                    //       type: "Outras marcas",
                    //       isNew: true,
                    //       sellerPrice: ,
                    //       paused: false,
                    //       status: 'ACTIVE',
                    //       images: [],
                    //       sellerId: sellerId,
                    //       onlineSeller: false,
                    //     ),
                    //     AdsModel(
                    //       deliveryType: "moto",
                    //       title: ,
                    //       description: ,
                    //       category: "Acessórios e eletrônicos",
                    //       option: "Outros",
                    //       type: "Outras marcas",
                    //       isNew: true,
                    //       sellerPrice: ,
                    //       paused: false,
                    //       status: 'ACTIVE',
                    //       images: [],
                    //       sellerId: sellerId,
                    //       onlineSeller: false,
                    //     ),
                    //     AdsModel(
                    //       deliveryType: "moto",
                    //       title: ,
                    //       description: ,
                    //       category: "Acessórios e eletrônicos",
                    //       option: "Outros",
                    //       type: "Outras marcas",
                    //       isNew: true,
                    //       sellerPrice: ,
                    //       paused: false,
                    //       status: 'ACTIVE',
                    //       images: [],
                    //       sellerId: sellerId,
                    //       onlineSeller: false,
                    //     ),
                    //     AdsModel(
                    //       deliveryType: "moto",
                    //       title: ,
                    //       description: ,
                    //       category: "Acessórios e eletrônicos",
                    //       option: "Outros",
                    //       type: "Outras marcas",
                    //       isNew: true,
                    //       sellerPrice: ,
                    //       paused: false,
                    //       status: 'ACTIVE',
                    //       images: [],
                    //       sellerId: sellerId,
                    //       onlineSeller: false,
                    //     ),
                    //   ];

                    //   for (final ads in adsArray) {
                    //     AdsModel newAds = ads;
                    //     newAds.totalPrice = newAds.sellerPrice * 1.25;
                    //     newAds.rateServicePrice = newAds.totalPrice * .2;
                    //     // print("newAds: ${newAds.toJson()}");
                    //     final adsRef =
                    //         FirebaseFirestore.instance.collection("ads").doc();
                    //     await adsRef.set(newAds.toJson());
                    //     await adsRef.update({
                    //       "id": adsRef.id,
                    //       "created_at": FieldValue.serverTimestamp(),
                    //     });
                    //     final adsDoc = await adsRef.get();
                    //     await FirebaseFirestore.instance
                    //         .collection("sellers")
                    //         .doc(sellerId)
                    //         .collection("ads")
                    //         .doc(adsRef.id)
                    //         .set(adsDoc.data()!);
                    //   }

                    //   // adsArray.map((ads) {
                    //   // });

                    //   overlayEntry.remove();

                    //   // Modular.to.pop();
                    // }
                    // FirebaseFirestore.instance
                    //     .collection("sellers")
                    //     .doc(mainStore.authStore.user!.uid)
                    //     .collection("ads")
                    //     .get()
                    //     .then((value) => value.docs.forEach((element) {
                    //           element.reference.delete();
                    //         })),
                    {
                  store.sellerCreateEdit = Seller().toJson();
                  Modular.to.pushNamed('/add-seller', arguments: false);
                },
                size: wXD(56, context),
                child: Icon(
                  Icons.add,
                  size: wXD(30, context),
                  color: primary,
                ),
              ),
            );
          }),
          const Positioned(
              top: 0, child: DefaultAppBar("Vendedores", noPop: true)),
        ],
      ),
    );
  }
}
