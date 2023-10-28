import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/modules/sellerOrders/widgets/order.dart';
import 'package:delivery_support/app/modules/sellerOrders/widgets/orders_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/models/order_model.dart';
import '../../shared/utilities.dart';
import '../../shared/widgets/center_load_circular.dart';

class SellerOrdersPage extends StatefulWidget {
  final String sellerId;
  const SellerOrdersPage({
    Key? key,
    required this.sellerId,
  }) : super(key: key);
  @override
  SellerOrdersPageState createState() => SellerOrdersPageState();
}

class SellerOrdersPageState extends State<SellerOrdersPage> {
  PageController pageController = PageController();

  @override
  void initState() {
    if (kDebugMode) {
      print('sellerId: ${widget.sellerId}');
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              getInProgressList(widget.sellerId),
              getConcludedList(widget.sellerId),
            ],
          ),
          OrdersAppBar(
            onTap: (int value) {
              pageController.jumpToPage(value);
            },
          ),
        ],
      ),
    );
  }

  Widget getInProgressList(String sellerId) {
    List viewableOrderStatus = [
      "REQUESTED",
      "PROCESSING",
      "SENDED",
      "DELIVERY_REQUESTED",
      "DELIVERY_REFUSED",
      "DELIVERY_ACCEPTED",
      "TIMEOUT",
      "REQUESTED",
    ];
    if (kDebugMode) {
      print(
          'getInProgressList store.viewableOrderStatus: $viewableOrderStatus');
    }
    return SingleChildScrollView(
      // controller: scrollController,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
            .doc(sellerId)
            .collection("orders")
            .where("status", whereIn: viewableOrderStatus)
            .orderBy("created_at", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (kDebugMode) {
            print('snapshot hasdata: ${snapshot.hasData}');
          }

          if (!snapshot.hasData) {
            return const CenterLoadCircular();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data!.docs;
          if (kDebugMode) {
            print('orders: $orders');
            print('orders.length: ${orders.length}');
          }
          return orders.isEmpty
              ? Container(
                  width: maxWidth(context),
                  height: maxHeight(context),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_copy_outlined,
                        size: wXD(90, context),
                      ),
                      Text(
                        "Sem pedidos em andamento",
                        style: textFamily(),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).viewPadding.top +
                            wXD(70, context)),
                    ...orders.map((DocumentSnapshot order) {
                      if (kDebugMode) {
                        print('order: ${order.id}');
                        print('order status: ${order.get("status")}');
                      }
                      return OrderWidget(
                        orderModel: Order.fromDoc(order),
                        // status: order.get("status"),
                      );
                    }),
                    SizedBox(height: wXD(120, context))
                  ],
                );
        },
      ),
    );
  }

  Widget getConcludedList(String sellerId) {
    List viewableOrderStatus = [
      "CANCELED",
      "REFUSED",
      "CONCLUDED",
    ];
    if (kDebugMode) {
      print('getConcludedList store.viewableOrderStatus: $viewableOrderStatus');
    }
    return SingleChildScrollView(
      // controller: scrollController,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
            .doc(sellerId)
            .collection("orders")
            .where("status", whereIn: viewableOrderStatus)
            .orderBy("created_at", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (kDebugMode) {
            print('snapshot hasdata: ${snapshot.hasData}');
          }

          if (!snapshot.hasData) {
            return const CenterLoadCircular();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data!.docs;
          if (kDebugMode) {
            print('orders: $orders');
            print('orders.length: ${orders.length}');
          }
          return orders.isEmpty
              ? Container(
                  width: maxWidth(context),
                  height: maxHeight(context),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_copy_outlined,
                        size: wXD(90, context),
                      ),
                      Text(
                        "Sem pedidos concluídos",
                        style: textFamily(),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top +
                          wXD(70, context),
                    ),
                    ...orders.map((order) {
                      if (kDebugMode) {
                        print('order: ${order.id}');
                        print('order status: ${order.get("status")}');
                      }
                      return OrderWidget(
                        orderModel: Order.fromDoc(order),
                        // status: order.get("status"),
                      );
                    }),
                    SizedBox(height: wXD(120, context))
                  ],
                );
        },
      ),
    );
  }
}
