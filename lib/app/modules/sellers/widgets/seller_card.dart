import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/modules/sellers/sellers_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/confirm_popup.dart';
import '../../main/main_store.dart';

class SellerCard extends StatefulWidget {
  final DocumentSnapshot sellerDoc;
  const SellerCard({Key? key, required this.sellerDoc}) : super(key: key);

  @override
  State<SellerCard> createState() => _SellerCardState();
}

class _SellerCardState extends State<SellerCard> {
  final MainStore mainStore = Modular.get();
  final SellersStore store = Modular.get();
  final LayerLink layerLink = LayerLink();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        mainStore.removeGlobalOverlay();
        store.sellerCreateEdit =
            widget.sellerDoc.data() as Map<String, dynamic>;
        Modular.to.pushNamed("/add-seller", arguments: true);
      },
      child: Padding(
        padding: EdgeInsets.all(wXD(8, context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: wXD(51, context),
              width: wXD(54, context),
              color: grey.withOpacity(.3),
              margin: EdgeInsets.only(right: wXD(9, context)),
              child: widget.sellerDoc["avatar"] == null
                  ? Image.asset(
                      './assets/img/default_alien.png',
                      fit: BoxFit.fill,
                      height: wXD(122, context),
                      width: wXD(116, context),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.sellerDoc["avatar"],
                      width: wXD(116, context),
                      height: wXD(122, context),
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, label, downloadProgress) {
                        if (kDebugMode) {
                          print(
                              'progressIndicatorBuilder downloadprogress: $downloadProgress');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sellerDoc["phone"],
                  style: textFamily(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: totalBlack,
                  ),
                ),
                Text(
                  widget.sellerDoc["store_name"] ?? "Sem nome",
                  style: textFamily(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: totalBlack,
                  ),
                ),
                SizedBox(
                  // color: Colors.red,
                  width: maxWidth(context) * .6,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.sellerDoc["store_category"] ?? "Sem categoria",
                      style: textFamily(
                        height: 1.6,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: veryLightGrey,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            widget.sellerDoc['status'] == "UNDER-ANALYSIS"
                ? CompositedTransformTarget(
                    link: layerLink,
                    child: IconButton(
                      onPressed: () {
                        mainStore.globalOverlay = sellerOverlay();
                        Overlay.of(context)!.insert(mainStore.globalOverlay!);
                        // mainStore.globalOverlay = activateAccountOverlay();
                        // Overlay.of(context)!.insert(mainStore.globalOverlay!);
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.red,
                      ),
                    ),
                  )
                : CompositedTransformTarget(
                    link: layerLink,
                    child: IconButton(
                      onPressed: () {
                        mainStore.globalOverlay = sellerOverlay();
                        Overlay.of(context)!.insert(mainStore.globalOverlay!);
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  OverlayEntry activateAccountOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        height: wXD(140, context),
        text: 'Tem certeza que deseja ativar esta conta?',
        onConfirm: () async {
          store.activateAccount(widget.sellerDoc.id);
          mainStore.removeGlobalOverlay();
        },
        onCancel: () {
          mainStore.removeGlobalOverlay();
        },
      ),
    );
  }

  OverlayEntry sellerOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                mainStore.removeGlobalOverlay();
              },
              child: Container(
                height: maxHeight(context),
                width: maxWidth(context),
                color: Colors.transparent,
              ),
            ),
            Positioned(
              // right: wXD(40, context),
              height: wXD(80, context),
              width: wXD(90, context),
              child: CompositedTransformFollower(
                offset: Offset(-wXD(60, context), 0),
                link: layerLink,
                child: Material(
                  color: white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: wXD(5, context)),
                    child: Column(
                      children: [
                        if (widget.sellerDoc['status'] != "UNDER-ANALYSIS")
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                mainStore.removeGlobalOverlay();
                                Modular.to.pushNamed("/seller-orders/",
                                    arguments: widget.sellerDoc.id);
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: wXD(5, context)),
                                child: Text(
                                  "Pedidos",
                                  style: textFamily(fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              // print("O inkWell do overlay");
                              mainStore.removeGlobalOverlay();
                              Modular.to.pushNamed("/advertisement/",
                                  arguments: widget.sellerDoc.id);
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: wXD(5, context)),
                              child: Text(
                                "Anúncios",
                                style: textFamily(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              // print("O inkWell do overlay");
                              mainStore.removeGlobalOverlay();
                              store.sellerCreateEdit = widget.sellerDoc.data()
                                  as Map<String, dynamic>;
                              Modular.to
                                  .pushNamed("/add-seller", arguments: true);
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: wXD(5, context)),
                              child: Text(
                                "Editar",
                                style: textFamily(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        if (widget.sellerDoc['status'] == "UNDER-ANALYSIS")
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                mainStore.globalOverlay =
                                    activateAccountOverlay();
                                Overlay.of(context)!
                                    .insert(mainStore.globalOverlay!);
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: wXD(5, context)),
                                child: Text(
                                  "Ativar",
                                  style: textFamily(fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
