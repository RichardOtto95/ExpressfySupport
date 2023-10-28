import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/shared/widgets/default_app_bar.dart';
import 'widgets/ads.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_support/app/shared/widgets/emtpy_state.dart';
import 'package:delivery_support/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_support/app/modules/advertisement/advertisement_store.dart';
import 'package:flutter/material.dart';

import 'widgets/delete_ads.dart';

class AdvertisementPage extends StatefulWidget {
  final String sellerId;

  const AdvertisementPage({Key? key, required this.sellerId}) : super(key: key);
  @override
  AdvertisementPageState createState() => AdvertisementPageState();
}

class AdvertisementPageState extends State<AdvertisementPage> {
  final AdvertisementStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  late OverlayEntry overlayEntry;
  final ScrollController scrollController = ScrollController();
  final ScrollController deleteScrollController = ScrollController();

  double offset = 0.0;
  double maxScrollExtent = 0.0;

  int limit = 20;

  double lastExtent = 0;

  @override
  initState() {
    store.sellerId = widget.sellerId;
    deleteScrollController.addListener(() {
      maxScrollExtent = deleteScrollController.position.maxScrollExtent;
      offset = deleteScrollController.offset;
    });

    scrollController.addListener(() {
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
              ScrollDirection.forward &&
          !store.addAds) {
        // mainStore.setVisibleNav(true);
        // print("setting true");
        store.setAddAds(true);
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          store.addAds) {
        // mainStore.setVisibleNav(false);
        // print("setting false");
        store.setAddAds(false);
      }
    });
    // mainStore.mainScrollController.addListener(() {
    //   if (mainStore.mainScrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //   } else if (mainStore.mainScrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (a) {
          mainStore.removeGlobalOverlay();
        },
        onPointerUp: (a) {
          // print('pointer up: ${scrollController.positions.length}');
          // print('pointer up: $offset');
          if (wXD(offset, context) < -55) {
            store.callDelete(removeDelete: true);
          } else if ((wXD(maxScrollExtent, context) + wXD(80, context)) <
              wXD(offset, context)) {
            store.callDelete(removeDelete: true);
            deleteScrollController.animateTo(0,
                duration: const Duration(milliseconds: 10), curve: Curves.ease);
          }
        },
        child: Stack(
          children: [
            SizedBox(
              height: maxHeight(context),
              width: maxWidth(context),
              child: SingleChildScrollView(
                controller: scrollController,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(store.sellerId!)
                      .collection('ads')
                      .orderBy("created_at", descending: true)
                      .limit(limit)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CenterLoadCircular();
                    } else {
                      QuerySnapshot qs = snapshot.data!;
                      // qs.docs.forEach((adDoc) {});
                      // WidgetsBinding.instance!.addTimingsCallback((_) {
                      //   store.charging = store.setAdsValues(qs);
                      //   print("setting Ads values");
                      // });
                      // print("Stream do ads");
                      List<AdsModel> activeAds = store.setAdsValues(qs);
                      return Observer(
                        builder: (context) {
                          switch (store.adsStatusSelected) {
                            case 'ACTIVE':
                              return store.charging
                                  ? const CenterLoadCircular()
                                  : activeAds.isEmpty
                                      ? const EmptyState(
                                          title: 'Sem anúncios ativos')
                                      : Column(
                                          children: <Widget>[
                                            SizedBox(
                                                height:
                                                    viewPaddingTop(context) +
                                                        wXD(50, context)),
                                            ...activeAds.map(
                                              (ads) {
                                                String image = '';
                                                if (ads.images.isNotEmpty) {
                                                  image = ads.images.first;
                                                }
                                                return Ads(
                                                  ad: ads,
                                                  image: image,
                                                );
                                              },
                                            ),
                                            SizedBox(height: wXD(120, context)),
                                          ],
                                        );
                            case 'pending':
                              return store.charging
                                  ? const CenterLoadCircular()
                                  : store.pendingAds.isEmpty
                                      ? const EmptyState(
                                          title: 'Sem anúncios pendentes')
                                      : Column(
                                          children: <Widget>[
                                            SizedBox(height: wXD(123, context)),
                                            ...store.pendingAds.map(
                                              (ads) => Ads(
                                                ad: AdsModel(
                                                  id: ads.id,
                                                  title: ads.title,
                                                  sellerPrice: ads.sellerPrice,
                                                  paused: ads.paused,
                                                  highlighted: ads.highlighted,
                                                  description: ads.description,
                                                ),
                                                image:
                                                    'https://t2.tudocdn.net/518979?w=660&h=643',
                                              ),
                                            ),
                                            SizedBox(height: wXD(120, context))
                                          ],
                                        );
                            case 'expired':
                              return store.charging
                                  ? const CenterLoadCircular()
                                  : store.expiredAds.isEmpty
                                      ? const EmptyState(
                                          title: 'Sem anúncios expirados')
                                      : Column(
                                          children: <Widget>[
                                            SizedBox(height: wXD(123, context)),
                                            ...store.expiredAds.map(
                                              (ads) => Ads(
                                                ad: AdsModel(
                                                  id: ads.id,
                                                  title: ads.title,
                                                  sellerPrice: ads.sellerPrice,
                                                  paused: ads.paused,
                                                  highlighted: ads.highlighted,
                                                  description: ads.description,
                                                ),
                                                image:
                                                    'https://t2.tudocdn.net/518979?w=660&h=643',
                                              ),
                                            ),
                                            SizedBox(height: wXD(120, context))
                                          ],
                                        );
                            default:
                              return const Text('Is wroooooooong');
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            // AdvertisementAppBar(),
            const DefaultAppBar("Anúncios"),
            Observer(builder: (context) {
              return AnimatedPositioned(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
                bottom: wXD(127, context),
                right: store.addAds ? wXD(17, context) : wXD(-56, context),
                child: FloatingCircleButton(
                  onTap: () async => await
                      // FirebaseFirestore.instance
                      //     .collection("sellers")
                      //     .doc(mainStore.authStore.user!.uid)
                      //     .collection("ads")
                      //     .get()
                      //     .then((value) => value.docs.forEach((element) {
                      //           element.reference.delete();
                      //         })),
                      Modular.to.pushNamed('/advertisement/create-ads'),
                  size: wXD(56, context),
                  child: Icon(
                    Icons.add,
                    size: wXD(30, context),
                    color: primary,
                  ),
                ),
              );
            }),
            Observer(builder: (context) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: store.delete ? 2 : 0, sigmaY: store.delete ? 2 : 0),
                child: AnimatedOpacity(
                  opacity: store.delete ? .6 : 0,
                  duration: Duration(seconds: 1),
                  child: GestureDetector(
                    onTap: () => store.callDelete(removeDelete: true),
                    child: Container(
                      height: store.delete ? maxHeight(context) : 0,
                      width: store.delete ? maxWidth(context) : 0,
                      color: totalBlack,
                    ),
                  ),
                ),
              );
            }),
            Observer(builder: (context) {
              return AnimatedPositioned(
                top: store.delete ? 0 : maxHeight(context),
                duration: Duration(seconds: 1),
                curve: Curves.ease,
                child: DeleteAds(
                  scrollController: deleteScrollController,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
