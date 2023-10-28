import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/modules/allOrders/widgets/order.dart';
import 'package:delivery_support/app/modules/allOrders/widgets/orders_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/order_model.dart';
import '../../core/models/time_model.dart';
import '../../shared/color_theme.dart';
import '../../shared/utilities.dart';
import '../../shared/widgets/center_load_circular.dart';
import '../main/main_store.dart';
import 'allOrders_store.dart';

class AllOrdersPage extends StatefulWidget {
  const AllOrdersPage({
    Key? key,
  }) : super(key: key);
  @override
  AllOrdersPageState createState() => AllOrdersPageState();
}

class AllOrdersPageState extends State<AllOrdersPage> {
  final MainStore mainStore = Modular.get();
  final AllOrdersStore store = Modular.get();
  PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();
  int limit = 25;
  bool hasMore = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 150) && hasMore) {
        setState(() {
          limit += 25;
        });
      }

      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      }
    });
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
              getInProgressList(),
              getConcludedList(),
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

  Widget getInProgressList() {
    List viewableOrderStatus = [
      "SENDED",
      "PROCESSING",
      "DELIVERY_REQUESTED",
      "DELIVERY_REFUSED",
      "DELIVERY_ACCEPTED",
      "TIMEOUT",
      "REQUESTED",
    ];
    return Observer(
      builder: (context) {
        if (kDebugMode) {
          print('store.filterText: ${store.filterText}');
        }
        return SingleChildScrollView(
          controller: scrollController,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .where('created_at', isGreaterThanOrEqualTo: store.startTimestamp)
                .where('created_at', isLessThanOrEqualTo: store.endTimestamp)
                .where('code', isEqualTo: store.filterText)
                .where("status", whereIn: viewableOrderStatus)
                .limit(limit)
                .orderBy("created_at", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              print('getInProgressList snapshot.hasdata: ${snapshot.hasData}');
              if(snapshot.hasError){
                if (kDebugMode) {
                  print(snapshot.error);
                }
              }

              if (!snapshot.hasData) {
                return const CenterLoadCircular();
              }
              List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
                  snapshot.data!.docs;
              hasMore = orders.length == limit;
              return orders.isEmpty
                  ? SizedBox(
                    width: maxWidth(context),
                    height: maxHeight(context),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).viewPadding.top +
                              wXD(75, context)),
                        Filter(),
                        const Spacer(),
                        Icon(
                          Icons.file_copy_outlined,
                          size: wXD(90, context),
                        ),
                        Text(
                          "Sem pedidos em andamento",
                          style: textFamily(),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  )
                  : Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).viewPadding.top +
                                wXD(75, context)),
                        Filter(),
                        ...orders.map((DocumentSnapshot order) {
                          return OrderWidget(
                            orderModel: Order.fromDoc(order),
                          );
                        }),
                        hasMore ? const CircularProgressIndicator(color: primary,) : Container(),
                        SizedBox(height: wXD(120, context))
                      ],
                    );
            },
          ),
        );
      }
    );
  }

  Widget getConcludedList() {
    List viewableOrderStatus = [
      "CANCELED",
      "REFUSED",
      "CONCLUDED",
    ];
    return Observer(
      builder: (context) {
        if (kDebugMode) {
          print('store.filterText: ${store.filterText}');
        }
        return SingleChildScrollView(
          controller: scrollController,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .where('created_at', isGreaterThanOrEqualTo: store.startTimestamp)
                .where('created_at', isLessThanOrEqualTo: store.endTimestamp)
                .where('code', isEqualTo: store.filterText)
                .where("status", whereIn: viewableOrderStatus)
                .limit(limit)
                .orderBy("created_at", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                if (kDebugMode) {
                  print(snapshot.error);
                }
              }

              if (!snapshot.hasData) {
                return const CenterLoadCircular();
              }
              List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
                  snapshot.data!.docs;
              hasMore = orders.length == limit;
              return orders.isEmpty
                  ? SizedBox(
                      width: maxWidth(context),
                      height: maxHeight(context),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).viewPadding.top + wXD(75, context),
                          ),  
                          Filter(),
                          const Spacer(),
                          Icon(
                            Icons.file_copy_outlined,
                            size: wXD(90, context),
                          ),
                          Text(
                            "Sem pedidos concluídos",
                            style: textFamily(),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).viewPadding.top + wXD(75, context),
                        ),
                        Filter(),
                        ...orders.map((order) {
                          return OrderWidget(
                            orderModel: Order.fromDoc(order),
                          );
                        }),
                        hasMore ? const CircularProgressIndicator(color: primary,) : Container(),
                        SizedBox(height: wXD(120, context))
                      ],
                    );
            },
          ),
        );
      }
    );
  }
}

class Filter extends StatelessWidget {
  final AllOrdersStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();

  OverlayEntry getFilterOverlay() {
    double opacity = 0;
    double sigma = 0;
    double right = -270;
    bool backing = false;

    Widget getCheckPeriod(String title, int index) {
      return Observer(builder: (context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                store.filterAltered(index);
              },
              child: Container(
                margin: EdgeInsets.only(
                    right: wXD(16, context), top: wXD(15, context)),
                height: wXD(16, context),
                width: wXD(16, context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary),
                  color: white,
                ),
                alignment: Alignment.center,
                child: Container(
                  height: wXD(10, context),
                  width: wXD(10, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: store.filterIndex == index 
                      ? primary
                      : Colors.transparent,
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: textFamily(fontSize: 12, color: grey),
            ),
          ],
        );
      });
    }

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          height: maxHeight(context),
          width: maxWidth(context),
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, stateSet) {
                if (!backing) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    stateSet(() {
                      opacity = .51;
                      sigma = 3;
                      right = 0;
                    });
                  });
                }
                return Stack(
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        backing = true;
                        stateSet(() {
                          opacity = 0;
                          sigma = 0;
                          right = -270;
                          Future.delayed(
                            const Duration(milliseconds: 400),
                            () {
                              store.filterOverlay!.remove();
                              store.filterOverlay = null;
                              store.filterAltered(store.previousFilterIndex);
                            },
                          );
                        });
                      },
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            totalBlack.withOpacity(.2),
                            BlendMode.color,
                          ),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                            opacity: opacity,
                            child: Container(
                              color: totalBlack,
                              height: maxHeight(context),
                              width: maxWidth(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease,
                      right: right,
                      child: Container(
                        height: maxHeight(context),
                        width: wXD(260, context),
                        decoration: const BoxDecoration(
                          color: Color(0xffF7F7F7),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(80)),
                        ),
                        padding: EdgeInsets.fromLTRB(
                          wXD(11, context),
                          wXD(34, context),
                          wXD(8, context),
                          wXD(0, context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    backing = true;
                                    stateSet(() {
                                      opacity = 0;
                                      sigma = 0;
                                      right = -270;
                                      Future.delayed(
                                        const Duration(milliseconds: 400),
                                        () {
                                          store.filterOverlay!.remove();
                                          store.filterOverlay = null;
                                          store.filterAltered(store.previousFilterIndex);
                                        },
                                      );
                                    });
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: wXD(20, context),
                                    color: grey,
                                  ),
                                ),
                                const Spacer(flex: 3),
                                InkWell(
                                  onTap: () {
                                    stateSet(() {
                                      store.filterAltered(-1);
                                      backing = true;
                                      opacity = 0;
                                      sigma = 0;
                                      right = -270;
                                      Future.delayed(
                                        const Duration(milliseconds: 400),
                                        () {
                                          store.filterOverlay!.remove();
                                          store.filterOverlay = null;
                                          store.filterBool = true;
                                          store.filterText = null;
                                          store.textEditingController.clear();
                                        },
                                      );
                                    });
                                  },
                                  child: Text(
                                    "Limpar",
                                    style: textFamily(
                                      color: grey,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    if(store.filterIndex != 6 || _formKey.currentState!.validate()){
                                      store.filter();
                                      backing = true;
                                      stateSet(() {
                                        opacity = 0;
                                        sigma = 0;
                                        right = -270;
                                        Future.delayed(
                                          const Duration(milliseconds: 400),
                                          () {
                                            store.filterOverlay!.remove();
                                            store.filterOverlay = null;
                                            store.filterBool = true;
                                          },
                                        );
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Filtrar",
                                    style: textFamily(
                                      color: primary,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: wXD(9, context)),
                              width: wXD(241, context),
                              color: grey.withOpacity(.2),
                              height: wXD(.5, context),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  wXD(10, context),
                                  wXD(13, context),
                                  wXD(0, context),
                                  wXD(20, context)),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Período",
                                      style: textFamily(
                                        color: primary,
                                      ),
                                    ),
                                    getCheckPeriod("Hoje", 0),
                                    getCheckPeriod("Ontem", 1),
                                    getCheckPeriod("1ª quinzena do mês", 2),
                                    getCheckPeriod("2ª quinzena do mês", 3),
                                    getCheckPeriod("Mês passado", 4),
                                    SizedBox(height: wXD(20, context)),
                                    Text(
                                      "Período específico",
                                      style: textFamily(
                                        color: primary,
                                      ),
                                    ),
                                    SizedBox(height: wXD(15, context)),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {                                          
                                            if(store.filterIndex != 5){
                                              store.previousFilterIndex = store.filterIndex;
                                              store.filterIndex = 5;
                                            }
                                            pickDate(context, onConfirm: (date) {
                                              // if (kDebugMode) {
                                              //   print("date: $date");
                                              // }
                                               if(date != null){
                                                if(store.endDate != null){
                                                  if(date.isAfter(store.endDate!)){
                                                    showToast("A data inicial não pode ser depois da final");
                                                  } else {
                                                    store.startDate = date;                                                  
                                                  }
                                                } else {
                                                  store.startDate = date;
                                                }
                                              } else {
                                                store.filterIndex = store.previousFilterIndex;
                                              }
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: wXD(4, context)),
                                                height: wXD(29, context),
                                                width: wXD(76, context),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffe4e4e4),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Data inicial",
                                                  style: textFamily(
                                                    fontSize: 10,
                                                    color: textGrey,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                TimeModel().date(
                                                  store.startDate == null
                                                      ? null
                                                      : Timestamp.fromDate(
                                                          store.startDate!,
                                                      ),
                                                ),
                                                style: textFamily(
                                                  fontSize: 10,
                                                  color: textGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: wXD(10, context)),
                                        GestureDetector(
                                          onTap: () async {
                                            if(store.filterIndex != 5){
                                              store.previousFilterIndex = store.filterIndex;
                                              store.filterIndex = 5;
                                            }
                                            pickDate(context, onConfirm: (date) {
                                              // if (kDebugMode) {
                                              //   print("date: $date");
                                              // }
                                              if(date != null){
                                                if(store.startDate != null){
                                                  if(date.isBefore(store.startDate!)){
                                                    showToast("A data final não pode ser antes da inicial");
                                                  } else {
                                                    store.endDate = date;                                                  
                                                  }
                                                } else {
                                                  store.endDate = date;
                                                }
                                              } else {
                                                store.filterIndex = store.previousFilterIndex;
                                              }
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: wXD(29, context),
                                                width: wXD(76, context),
                                                margin: EdgeInsets.only(
                                                    bottom: wXD(4, context)),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffe4e4e4),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Data final",
                                                  style: textFamily(
                                                    fontSize: 10,
                                                    color: textGrey,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                TimeModel().date(store.endDate == null
                                                  ? null
                                                  : Timestamp.fromDate(
                                                      store.endDate!,
                                                  ),
                                                ),
                                                style: textFamily(
                                                  fontSize: 10,
                                                  color: textGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: wXD(15, context)),
                                    Text(
                                      "Id do pedido",
                                      style: textFamily(
                                        color: primary,
                                      ),
                                    ),
                                    SizedBox(
                                      child: TextFormField(
                                        maxLength: 5,
                                        onTap: (){
                                          if(store.filterIndex != 6){
                                            // store.previousFilterIndex = store.filterIndex;
                                            store.filterIndex = 6;
                                            store.startDate = null;
                                            store.endDate = null;
                                            store.startTimestamp = null;
                                            store.endTimestamp = null;
                                          }
                                        },
                                        validator: (String? value){
                                          if(value == null || value.length < 5){
                                            return "campo incompleto";
                                          }
                                        },
                                        controller: store.textEditingController,
                                        decoration: InputDecoration.collapsed(
                                          hintText: "12ABCD",
                                          hintStyle: textFamily(fontSize: 14, color: darkGrey.withOpacity(.7)),  
                                        ),
                                      ),
                                    ),
                                    // SizedBox(height: wXD(15, context)),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: wXD(241, context),
                              color: grey.withOpacity(.2),
                              height: wXD(.5, context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Observer(
                      builder: (context) {
                        if (store.removeOverlay) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((timeStamp) {
                            stateSet(() {
                              backing = true;
                              store.removeOverlay = false;
                              opacity = 0;
                              sigma = 0;
                              right = -270;
                              Future.delayed(
                                const Duration(milliseconds: 400),
                                () {
                                  store.filterOverlay!.remove();
                                  store.filterOverlay = null;
                                },
                              );
                            });
                          });
                        }
                        return Container();
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Center(
          child: Container(
            height: wXD(42, context),
            width: wXD(343, context),
            padding: EdgeInsets.symmetric(horizontal: wXD(13, context)),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              color: lightOrange,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                  color: totalBlack.withOpacity(.2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  getText(store.filterIndex),
                  style: textFamily(
                    fontSize: 14,
                    color: primary,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    store.insertOverlay(context, getFilterOverlay());
                  },
                  child: Text(
                    "Filtros",
                    style: textFamily(
                      fontSize: 10,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  String getText(int index){
    switch (index) {
      case -1:        
        return 'Todos';

      case 0:
        String date = store.nowDate.day.toString().padLeft(2, '0') + '/' + store.nowDate.month.toString().padLeft(2, '0') + '/' + store.nowDate.year.toString();
        return 'Hoje - ' + date;

      case 1:
        String date = store.yesterdayDate.day.toString().padLeft(2, '0') + '/' + store.yesterdayDate.month.toString().padLeft(2, '0') + '/' + store.yesterdayDate.year.toString();
        return 'Ontem - ' + date;

      case 2:
        return '1º quinzena do mês';

      case 3:
        return '2º quinzena do mês';

      case 4:
        return 'Mês passado';

      case 5:
        String date = store.startDate!.day.toString().padLeft(2, '0') + '/' + store.startDate!.month.toString().padLeft(2, '0') + '/' + store.startDate!.year.toString();

        date += " até ";
        date += store.endDate!.day.toString().padLeft(2, '0') + '/' + store.endDate!.month.toString().padLeft(2, '0') + '/' + store.endDate!.year.toString();

        return date;

      case 6:
        print('store.textEditingController.text: ${store.textEditingController.text}');
        return "Id do pedido: ${store.textEditingController.text}";
      
      default:
      return '';
    }
  }
}