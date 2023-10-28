import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/confirm_popup.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Ads extends StatefulWidget {
  final AdsModel ad;
  final String image;
  const Ads({
    Key? key,
    required this.ad,
    required this.image,
  }) : super(key: key);

  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  final MainStore mainStore = Modular.get();
  final AdvertisementStore store = Modular.get();

  OverlayEntry? confirmPauseOverlay;

  final LayerLink _layerLink = LayerLink();

  OverlayEntry getOverlayEntry() {
    // print("ads Model: ${AdsModel().toJson(widget.ad)}");
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(140, context),
        width: wXD(130, context),
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(wXD(-115, context), wXD(21, context)),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(left: wXD(12, context)),
              height: wXD(140, context),
              width: wXD(130, context),
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset.zero,
                    color: Color(0x30000000),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        mainStore.removeGlobalOverlay();

                        // print('onTap: ${widget.ad.toJson()}');
                        mainStore.setAdsId(widget.ad.id);
                        // mainStore.adsId = widget.ad.id;

                        // print('onTap: ${mainStore.adsId}');
                        await Modular.to.pushNamed('/product');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: wXD(18, context),
                            color: primary,
                          ),
                          Text(
                            '  Visualizar',
                            style: textFamily(
                              color: primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        print("widget.ad: ${widget.ad.toJson()}");
                        store.setAdEdit(widget.ad);
                        store.adEdit.images = widget.ad.images;
                        store.getFinalPrice(widget.ad.totalPrice);
                        store.setEditingAd(true);
                        mainStore.removeGlobalOverlay();

                        Modular.to.pushNamed('/advertisement/create-ads');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: wXD(18, context),
                            color: primary,
                          ),
                          Text(
                            '  Editar',
                            style: textFamily(
                              color: primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        confirmPauseOverlay = OverlayEntry(
                          builder: (context) => ConfirmPopup(
                            height: wXD(140, context),
                            text:
                                'Tem certeza que deseja pausar esta publicação?',
                            onConfirm: () async {
                              await store.pauseAds(
                                  adsId: widget.ad.id,
                                  pause: !widget.ad.paused,
                                  context: context);
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              mainStore.removeGlobalOverlay();
                            },
                            onCancel: () {
                              confirmPauseOverlay!.remove();
                              confirmPauseOverlay = null;
                              mainStore.removeGlobalOverlay();
                            },
                          ),
                        );
                        Overlay.of(context)!.insert(confirmPauseOverlay!);
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.ad.paused
                                ? Icons.play_arrow_rounded
                                : Icons.pause,
                            size: wXD(18, context),
                            color: primary,
                          ),
                          Text(
                            widget.ad.paused ? 'Despausar' : '  Pausar',
                            style: textFamily(
                              color: primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        mainStore.removeGlobalOverlay();
                        mainStore.paginateEnable = false;
                        mainStore.setVisibleNav(false);
                        store.callDelete(ad: widget.ad);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: wXD(18, context),
                            color: primary,
                          ),
                          Text(
                            '  Excluir',
                            style: textFamily(
                              color: primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: wXD(140, context),
            width: wXD(352, context),
            margin: EdgeInsets.only(bottom: wXD(12, context)),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffF1F1F1)),
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              color: white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: Color(0x20000000),
                )
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    mainStore.removeGlobalOverlay();
                    mainStore.setAdsId(widget.ad.id);
                    await Modular.to.pushNamed('/product');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: darkGrey.withOpacity(.2)))),
                    padding: EdgeInsets.only(bottom: wXD(7, context)),
                    margin: EdgeInsets.fromLTRB(
                      wXD(19, context),
                      wXD(17, context),
                      wXD(6, context),
                      wXD(0, context),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: widget.image == ''
                              ? Image.asset(
                                  'assets/img/no-image-icon.png',
                                  height: wXD(65, context),
                                  width: wXD(62, context),
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, progress) =>
                                          const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(primary),
                                  ),
                                  imageUrl: widget.image,
                                  height: wXD(65, context),
                                  width: wXD(62, context),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          width: wXD(248, context),
                          height: wXD(70, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: wXD(3, context)),
                              Text(
                                widget.ad.title,
                                style: textFamily(color: totalBlack),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: wXD(3, context)),
                              Text(
                                widget.ad.description,
                                style: textFamily(color: lightGrey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SizedBox(height: wXD(3, context)),
                              const Spacer(),
                              Text(
                                'R\$ ${formatedCurrency(widget.ad.totalPrice)}',
                                style: textFamily(color: primary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                widget.ad.paused
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pause,
                            size: wXD(30, context),
                            color: primary,
                          ),
                          Text(
                            '  Anúncio pausado',
                            style: textFamily(
                              fontSize: 18,
                              color: primary,
                            ),
                          ),
                        ],
                      )
                    : widget.ad.highlighted
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: wXD(30, context),
                                color: primary,
                              ),
                              Text(
                                '  Anúncio destacado',
                                style: textFamily(
                                  fontSize: 18,
                                  color: primary,
                                ),
                              ),
                            ],
                          )
                        // Text(
                        //     'Anúncio destacado',
                        //     style: textFamily(
                        //       color: primary,
                        //       fontSize: 14,
                        //     ),
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis,
                        //   )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: wXD(20, context)),
                                child: Text(
                                  'Destaque e venda mais rápido',
                                  style: textFamily(
                                    color: darkGrey.withOpacity(.7),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  confirmPauseOverlay = OverlayEntry(
                                    builder: (context) => ConfirmPopup(
                                      height: wXD(140, context),
                                      text:
                                          'Tem certeza que deseja destacar esta publicação?',
                                      onConfirm: () async {
                                        await store.highlightAd(
                                            adsId: widget.ad.id,
                                            context: context);
                                        confirmPauseOverlay!.remove();
                                        confirmPauseOverlay = null;
                                      },
                                      onCancel: () {
                                        confirmPauseOverlay!.remove();
                                        confirmPauseOverlay = null;
                                      },
                                    ),
                                  );
                                  Overlay.of(context)!
                                      .insert(confirmPauseOverlay!);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: wXD(6, context)),
                                  height: wXD(32, context),
                                  width: wXD(87, context),
                                  decoration: const BoxDecoration(
                                    color: primary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                        color: Color(0x20000000),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Destacar',
                                    style: textFamily(
                                      fontSize: 12,
                                      color: white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            top: wXD(0, context),
            right: wXD(0, context),
            child: CompositedTransformTarget(
              link: _layerLink,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(90),
                child: IconButton(
                  onPressed: () {
                    mainStore.setGlobalOverlay(getOverlayEntry(), context);
                  },
                  icon: Icon(
                    Icons.more_vert,
                    size: wXD(20, context),
                    color: primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
