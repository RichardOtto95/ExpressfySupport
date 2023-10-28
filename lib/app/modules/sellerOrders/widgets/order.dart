import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../../../core/models/order_model.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../../../shared/widgets/confirm_popup.dart';
import '../../../shared/widgets/load_circular_overlay.dart';
import '../sellerOrders_store.dart';

class OrderWidget extends StatefulWidget {
  final Order orderModel;

  const OrderWidget({
    Key? key,
    required this.orderModel,
  }) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final SellerOrdersStore store = Modular.get();
  OverlayEntry? overlayEntry;
  bool paid = false;

  @override
  initState() {
    paid = widget.orderModel.paid!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: wXD(6, context),
              left: wXD(4, context),
              top: wXD(20, context),
            ),
            child: Text(
              getOrderDate(widget.orderModel.createdAt!.toDate()),
              style: textFamily(
                fontSize: 14,
                color: textDarkGrey,
              ),
            ),
          ),
          Container(
            height: wXD(140, context),
            width: wXD(352, context),
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
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: darkGrey.withOpacity(.2)))),
                  padding: EdgeInsets.only(bottom: wXD(7, context)),
                  margin: EdgeInsets.fromLTRB(
                    wXD(19, context),
                    wXD(18, context),
                    wXD(15, context),
                    wXD(0, context),
                  ),
                  alignment: Alignment.center,
                  child: FutureBuilder<
                      List<DocumentSnapshot<Map<String, dynamic>>>>(
                    future: widget.orderModel.getAds(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: wXD(65, context),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              primary,
                            ),
                          ),
                        );
                      }
                      if (kDebugMode) {
                        print(
                            "snapshot.data!.first.id: ${snapshot.data!.first.id}");
                      }
                      return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("ads")
                              .doc(snapshot.data!.first["ads_id"])
                              .snapshots(),
                          builder: (context, adsSnapshot) {
                            if (!snapshot.hasData || adsSnapshot.data == null) {
                              return const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(primary),
                              );
                            } else {
                              DocumentSnapshot pdt = adsSnapshot.data!;
                              if (kDebugMode) {
                                print("pdt: ${pdt.id}");
                              }
                              return InkWell(
                                onTap: () async {
                                  // await Modular.to.pushNamed(
                                  //   '/orders/order-details',
                                  //   arguments: orderModel,
                                  // );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl: pdt['images'].first,
                                        height: wXD(65, context),
                                        width: wXD(62, context),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: wXD(8, context)),
                                          width: wXD(220, context),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(height: wXD(3, context)),
                                              Text(
                                                pdt['title'],
                                                style: textFamily(
                                                    color: totalBlack),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: wXD(3, context)),
                                              Text(
                                                pdt['description'],
                                                style: textFamily(
                                                    color: lightGrey),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: wXD(3, context)),
                                              Text(
                                                widget.orderModel.totalAmount! >
                                                        1
                                                    ? '${widget.orderModel.totalAmount} itens'
                                                    : '${widget.orderModel.totalAmount} item',
                                                style: textFamily(
                                                    color:
                                                        grey.withOpacity(.7)),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: wXD(10, context)),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: wXD(14, context),
                                          color: grey.withOpacity(.7),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                    },
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.orderModel.paid!) {
                          showToast("Pedido pago");
                          return;
                        }
                        overlayEntry = getOverlay();
                        Overlay.of(context)?.insert(overlayEntry!);
                      },
                      child: Text(
                        paid ? "Pago" : "Não pago",
                        style: textFamily(
                          color: primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        text: paid
            ? 'Tem certeza que deseja marcar como não pago?'
            : 'Tem certeza que deseja marcar como pago?',
        onConfirm: () async {
          OverlayEntry overlayCircular =
              OverlayEntry(builder: (context) => const LoadCircularOverlay());
          Overlay.of(context)!.insert(overlayCircular);
          await store.wasPaid(widget.orderModel);
          overlayCircular.remove();
        },
        onCancel: () {
          overlayEntry!.remove();
        },
      ),
    );
  }

  String getOrderDate(DateTime date) {
    String strDate = '';

    String weekDay = DateFormat('EEEE').format(date);

    String month = DateFormat('MMMM').format(date);

    strDate =
        "${weekDay.substring(0, 1).toUpperCase()}${weekDay.substring(1, 3)} ${date.day} $month ${date.year}";

    return strDate;
  }
}
