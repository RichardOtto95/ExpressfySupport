import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/modules/customers/customers_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../../main/main_store.dart';
import 'recharge_popup.dart';

class CustomerCard extends StatefulWidget {
  final DocumentSnapshot customerDoc;
  const CustomerCard({Key? key, required this.customerDoc}) : super(key: key);

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  final MainStore mainStore = Modular.get();
  final CustomersStore store = Modular.get();
  final LayerLink layerLink = LayerLink();
  // bool? selected = false;
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
            child: widget.customerDoc["avatar"] == null
                ? Image.asset(
                    './assets/img/default_alien.png',
                    fit: BoxFit.fill,
                    height: wXD(122, context),
                    width: wXD(116, context),
                  )
                : CachedNetworkImage(
                    imageUrl: widget.customerDoc["avatar"],
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
              Text(
                widget.customerDoc["phone"],
                style: textFamily(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: totalBlack,
                ),
              ),
              Text(
                "Saldo em conta: " + formatedCurrency(widget.customerDoc["account_balance"]) + "R\$",
                style: textFamily(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: totalBlack,
                ),
              ),
            ],
          ),
          const Spacer(),
          Observer(
            builder: (context) {
              if (kDebugMode) {
                print('observer: ${store.allCustomers}');
              }
              if(store.sendingCoupon){
                return Checkbox(
                  activeColor: primary,
                  value: (store.allCustomers == null || store.allCustomers == false ? store.customersSelected.contains(widget.customerDoc.id) : true),
                  onChanged: (bool? value){
                    print('store.customersSelected: ${store.customersSelected}');
                    setState(() {
                      // selected = value;    
                      if(value!){
                        store.customersSelected.add(widget.customerDoc.id);
                      } else {
                        store.customersSelected.remove(widget.customerDoc.id);
                      }
                    });
                  },
                );
              }
              return CompositedTransformTarget(
                link: layerLink,
                child: IconButton(
                  onPressed: () {
                    mainStore.globalOverlay = customerOverlay();
                    Overlay.of(context)!.insert(mainStore.globalOverlay!);
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  OverlayEntry getRechargeOverlay() {
    return OverlayEntry(
      builder: (context) => RechargePopUp(
        text: 'Deseja realizar uma recarga para ${widget.customerDoc['username']} de quanto?',
        // onConfirm: (num value) async {
        //   print('onConfirm: $value');

        // },
        onCancel: () {
          store.overlayRecharge!.remove();
          store.overlayRecharge = null;
        },
        customerId: widget.customerDoc.id,
      ),
    );
  }

  OverlayEntry customerOverlay() {
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
              height: wXD(70, context),
              width: wXD(90, context),
              child: CompositedTransformFollower(
                offset: Offset(-wXD(60, context), 0),
                link: layerLink,
                child: Material(
                  color: white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  elevation: 2,
                  child: Column(
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            mainStore.removeGlobalOverlay();
                            store.overlayRecharge = getRechargeOverlay();
                            Overlay.of(context)?.insert(store.overlayRecharge!);
                            // Modular.to.pushNamed("/seller-orders/",
                            //     arguments: widget.sellerDoc.id);
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: wXD(5, context)),
                            child: Text(
                              "Recarga",
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
          ],
        );
      },
    );
  }
}
