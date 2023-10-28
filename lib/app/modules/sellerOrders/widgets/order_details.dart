// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import '../../../shared/color_theme.dart';
// import '../../../shared/utilities.dart';
// import '../orders_store.dart';

// class OrderDetails extends StatefulWidget {
//   // final String orderId;

//   const OrderDetails({
//     Key? key,
//     // required this.orderId,
//   }) : super(key: key);

//   @override
//   State<OrderDetails> createState() => _OrderDetailsState();
// }

// class _OrderDetailsState extends State<OrderDetails> {
//   // final MainStore mainStore = Modular.get();
//   final OrdersStore store = Modular.get();

//   @override
//   void initState() {
//     // print('OrderDetails page: ${widget.orderId}');
//     // store.addOrderListener(widget.orderId, context);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // store.clearShippingDetails();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Observer(builder: (context) {
//         // print(
//         //     'store.order: ${store.order} - store.destinationAddress: ${store.destinationAddress}');
//         return Stack(
//           children: [
//             // store.order == null || store.destinationAddress == null
//             //     ? CenterLoadCircular()
//             //     : 
//                 SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: wXD(101, context)),
//                         StatusForecast(
//                           status: store.order!.status!,
//                           deliveryForecast: store.deliveryForecast,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   left: wXD(32, context),
//                                   right: wXD(40, context)),
//                               child: Column(
//                                 children: getBools(4, store.order!.status!),
//                               ),
//                             ),
//                             Observer(builder: (context) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ...store.steps.map(
//                                     (step) => Step(
//                                       title: step['title'],
//                                       subTitle: step['sub_title'],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             })
//                           ],
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                   color: darkGrey.withOpacity(.2),
//                                 ),
//                             ),
//                           ),
//                         ),
//                         StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                           stream: FirebaseFirestore.instance
//                               .collection("sellers")
//                               // .doc(FirebaseAuth.instance.currentUser!.uid)
//                               // .collection("orders")
//                               // .doc(widget.orderId)
//                               // .collection("ads")
//                               .snapshots(),
//                           builder: (context, adsQue) {
//                             if (!adsQue.hasData) {
//                               // return adsOrderDataSkeleton(context);
//                             }
//                             return Column(
//                                 children: adsQue.data!.docs
//                                     .map((adsDoc) =>
//                                         AdsOrderData(adsDoc: adsDoc))
//                                     .toList());
//                           },
//                         ),
//                         Container(
//                           width: maxWidth(context),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: wXD(16, context),
//                             vertical: wXD(24, context),
//                           ),
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: darkGrey
//                                           .withOpacity(.2)))),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     size: wXD(25, context),
//                                     color: primary,
//                                   ),
//                                   SizedBox(width: wXD(12, context)),
//                                   Container(
//                                     width: wXD(250, context),
//                                     child: Text(
//                                       store
//                                           .destinationAddress!.formatedAddress!,
//                                       style: TextStyle(
//                                         color: darkGrey,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         fontFamily: 'Montserrat',
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   Container(
//                                     margin: EdgeInsets.fromLTRB(
//                                       wXD(38, context),
//                                       wXD(20, context),
//                                       wXD(40, context),
//                                       wXD(24, context),
//                                     ),
//                                     height: wXD(116, context),
//                                     width: wXD(279, context),
//                                     color: lightGrey.withOpacity(.2),
//                                     child: Observer(builder: (context) {
//                                       return GoogleMap(
//                                         initialCameraPosition: CameraPosition(
//                                             target:
//                                                 LatLng(-15.787763, -48.008072),
//                                             zoom: 11.5),
//                                         myLocationButtonEnabled: true,
//                                         scrollGesturesEnabled: false,
//                                         zoomControlsEnabled: false,
//                                         onMapCreated: (controller) {
//                                           store.googleMapController =
//                                               controller;
//                                         },
//                                         markers: {
//                                           if (store.origin != null)
//                                             store.origin!,
//                                           if (store.destination != null)
//                                             store.destination!,
//                                         },
//                                         polylines: {
//                                           if (store.info != null)
//                                             Polyline(
//                                                 polylineId: PolylineId(
//                                                     "overview_polyline"),
//                                                 color: Colors.red,
//                                                 width: 5,
//                                                 points: store
//                                                     .info!.polylinePoints
//                                                     .map((e) => LatLng(
//                                                         e.latitude,
//                                                         e.longitude))
//                                                     .toList())
//                                         },
//                                       );
//                                     }),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//             DefaultAppBar('Detalhes do envio'),
//           ],
//         );
//       }),
//     );
//   }

//   List<Widget> getBools(int steps, String status) {
//     int step = 0;
//     switch (status) {
//       case "REQUESTED":
//         step = 0;
//         break;
//       case "PROCESSING":
//         step = 1;
//         break;
//       case "DELIVERY_REFUSED":
//         step = 1;
//         break;
//       case "DELIVERY_ACCEPTED":
//         step = 1;
//         break;
//       case "DELIVERY_CANCELED":
//         step = 2;
//         break;
//       case "SENDED":
//         step = 2;
//         break;
//       case "CANCELED":
//         step = 1;
//         break;
//       case "REFUSED":
//         step = 0;
//         break;
//       case "CONCLUDED":
//         step = 3;
//         break;
//       default:
//         step = 0;
//         break;
//     }
//     List<Widget> balls = [];
//     for (var i = 0; i <= ((steps - 1) * 6); i++) {
//       bool sixMultiple = i % 6 == 0;
//       bool lessMultiple = (i + 1) % 6 != 0;
//       if (sixMultiple) {
//         // print('$i é multiplo de 6');
//         (status == "CANCELED" || status == "REFUSED") && i == step * 6
//             ? balls.add(RedBall(isRed: i == step * 6))
//             : balls.add(Ball(orange: i <= step * 6));
//       } else {
//         // print('$i não é multiplo de 6');
//         balls.add(LittleBall(
//           orange: i <= step * 6,
//           padding: lessMultiple,
//         ));
//       }
//     }
//     return balls;
//   }
// }

// class EvaluateOrderCard extends StatelessWidget {
//   final bool rated;
//   final double? rating;

//   final void Function() onTap;
//   EvaluateOrderCard({required this.onTap, required this.rated, this.rating});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: wXD(100, context),
//           width: wXD(343, context),
//           margin: EdgeInsets.symmetric(vertical: wXD(24, context)),
//           padding: EdgeInsets.symmetric(
//             horizontal: wXD(16, context),
//             vertical: wXD(13, context),
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(13)),
//             color: white,
//             boxShadow: [
//               BoxShadow(
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                   color: totalBlack.withOpacity(.2))
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 rated ? "Pedido avaliado" : 'Avalie o seu pedido',
//                 style: TextStyle(
//                   color: totalBlack,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w800,
//                   fontFamily: 'Montserrat',
//                 ),
//               ),
//               RatingBar(
//                 onRatingUpdate: (value) {},
//                 initialRating: rating ?? 0,
//                 ignoreGestures: true,
//                 glowColor: primary.withOpacity(.4),
//                 unratedColor: primary.withOpacity(.4),
//                 allowHalfRating: true,
//                 itemSize: wXD(35, context),
//                 ratingWidget: RatingWidget(
//                   full: Icon(Icons.star_rounded, color: primary),
//                   empty: Icon(Icons.star_outline_rounded,
//                       color: primary),
//                   half:
//                       Icon(Icons.star_half_rounded, color: primary),
//                 ),
//               ),
//               Text(
//                 rated
//                     ? "Esta é a média da sua avaliação"
//                     : 'Escolha de 1 a 5 estrelas para classificar',
//                 style: TextStyle(
//                   color: darkGrey,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'Montserrat',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RedBall extends StatelessWidget {
//   final bool isRed;

//   RedBall({Key? key, required this.isRed}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: wXD(7, context)),
//       height: wXD(6, context),
//       width: wXD(6, context),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isRed ? red : Color(0xffbdbdbd),
//       ),
//     );
//   }
// }

// class Ball extends StatelessWidget {
//   final bool orange;

//   const Ball({Key? key, required this.orange}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: wXD(7, context)),
//       height: wXD(6, context),
//       width: wXD(6, context),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: orange ? primary : Color(0xffbdbdbd),
//       ),
//     );
//   }
// }

// class LittleBall extends StatelessWidget {
//   final bool orange;
//   final bool padding;

//   const LittleBall({
//     Key? key,
//     required this.orange,
//     required this.padding,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // print('padding: $padding');
//     return Container(
//       margin: EdgeInsets.only(bottom: padding ? wXD(6, context) : 0),
//       height: wXD(4, context),
//       width: wXD(4, context),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: orange
//             ? primary.withOpacity(.5)
//             : Color(0xff78849e).withOpacity(.3),
//       ),
//     );
//   }
// }

// class Step extends StatelessWidget {
//   final String title, subTitle;
//   Step({
//     Key? key,
//     required this.title,
//     required this.subTitle,
//   }) : super(key: key);

//   final OrdersStore store = Modular.get();

//   @override
//   Widget build(BuildContext context) {
//     Color titleColor = textBlack;
//     Color textColor = darkGrey;
//     if (title == "Entregue" && store.order!.status != "CONCLUDED") {
//       titleColor = textBlack.withOpacity(.4);
//       textColor = textLightGrey;
//     }
//     return Container(
//       margin: EdgeInsets.only(bottom: wXD(28, context)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: titleColor,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: 'Montserrat',
//             ),
//           ),
//           Text(
//             subTitle,
//             style: TextStyle(
//               color: textColor,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               fontFamily: 'Montserrat',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
