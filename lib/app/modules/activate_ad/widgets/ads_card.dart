import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/modules/customers/customers_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/confirm_popup.dart';
import '../../../shared/widgets/load_circular_overlay.dart';
import '../../main/main_store.dart';
import '../activateAd_store.dart';

class AdsCard extends StatefulWidget {
  final DocumentSnapshot adsDoc;
  const AdsCard({Key? key, required this.adsDoc}) : super(key: key);

  @override
  State<AdsCard> createState() => _AdsCardState();
}

class _AdsCardState extends State<AdsCard> {
  final MainStore mainStore = Modular.get();
  final ActivateAdStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(wXD(8, context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: wXD(51, context),
            width: wXD(54, context),
            color: grey.withOpacity(.3),
            margin: EdgeInsets.only(right: wXD(9, context)),
            child: widget.adsDoc["images"].isEmpty
                ? Image.asset(
                    './assets/img/default_alien.png',
                    fit: BoxFit.fill,
                    height: wXD(122, context),
                    width: wXD(116, context),
                  )
                : CachedNetworkImage(
                    imageUrl: widget.adsDoc["images"].first,
                    width: wXD(116, context),
                    height: wXD(122, context),
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, label, downloadProgress) {
                      // print(
                      //     'progressIndicatorBuilder downloadprogress: $downloadProgress');
                      return const CircularProgressIndicator();
                    },
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: maxWidth(context) * .65,
                // color: Colors.red,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.adsDoc["title"],
                    style: textFamily(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: totalBlack,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                width: maxWidth(context) * .65,
                // color: Colors.red,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.adsDoc["description"],
                    style: textFamily(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: totalBlack,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              mainStore.globalOverlay = activateAccountOverlay();
              Overlay.of(context)!.insert(mainStore.globalOverlay!);
            },
            icon: const Icon(Icons.info_outline, color: Colors.red,),
          ),
        ],
      ),
    );
  }

  OverlayEntry activateAccountOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        height: wXD(140, context),
        text:
            'Tem certeza que deseja ativar este anúncio?',
        onConfirm: () async {
          OverlayEntry loadOverlay =
              OverlayEntry(builder: (context) => const LoadCircularOverlay());
          Overlay.of(context)!.insert(loadOverlay);
          await store.activateAd(widget.adsDoc.id);
          mainStore.removeGlobalOverlay();

          loadOverlay.remove();
        },
        onCancel: () {
          mainStore.removeGlobalOverlay();
        },
      ),
    );
  }
}
