import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_support/app/modules/customers/customers_store.dart';
import 'package:flutter/material.dart';
import '../../shared/color_theme.dart';
import '../../shared/utilities.dart';
import '../../shared/widgets/center_load_circular.dart';
import '../../shared/widgets/default_app_bar.dart';
import '../../shared/widgets/floating_circle_button.dart';
import '../main/main_store.dart';
import 'widgets/customer_card.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);
  @override
  CustomersPageState createState() => CustomersPageState();
}

class CustomersPageState extends State<CustomersPage> {
  final CustomersStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final ScrollController scrollController = ScrollController();  
  int limit = 20;
  double lastExtent = 0;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > (scrollController.position.maxScrollExtent - 300) && 
      lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          lastExtent = scrollController.position.maxScrollExtent;
          limit += 15;
        });
      }
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        store.visibleButton = false;
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        store.visibleButton = true;
        mainStore.setVisibleNav(true);
      }
    });
    super.initState();
  }

  @override
  void dispose(){
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if (kDebugMode) {
          print('onWillPop');
        }
        if(store.overlayLoad == null){       
          if(store.overlayConfirm != null){
            store.overlayConfirm!.remove();
            store.overlayConfirm = null;
          } else {
            if(store.overlayRecharge != null){
              store.overlayRecharge!.remove();
              store.overlayRecharge = null;
            } else {
              if(mainStore.globalOverlay != null){
                mainStore.globalOverlay!.remove();
                mainStore.globalOverlay = null;
              } else {
                setState(() {
                  store.cleanCache();                  
                });
              }
            }
          }
        }
        return false;
      },
      child: Scaffold(
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
                    .collection("customers")
                    .where("status", isEqualTo: "ACTIVE")
                    .orderBy("created_at", descending: true)
                    .limit(limit)
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
                    QuerySnapshot customersQuery = snapshot.data!;
                    if (kDebugMode) {
                      print('customersQuery: ${customersQuery.docs.length}');
                    }
                    return Listener(
                      onPointerDown: (event) {
                        mainStore.removeGlobalOverlay();
                      },
                      child: Column(children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(50, context)),
                        Observer(
                          builder: ((context) {
                            return  store.sendingCoupon ? Container(
                              margin: EdgeInsets.only(left: wXD(8, context), right: wXD(9, context)),
                              child: Row(
                                children: [
                                  const Text("Selecionar todos"),
                                  const Spacer(),
                                  Checkbox(
                                    activeColor: primary,
                                    value: store.allCustomers ?? false,
                                    onChanged: (bool? value){
                                      setState(() {                                      
                                        store.allCustomers = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ) : Container();
                          }),
                        ),
                        // if(store.sendingCoupon)
                        //   Container(
                        //     margin: EdgeInsets.only(left: wXD(8, context), right: wXD(9, context)),
                        //     child: Row(
                        //       children: [
                        //         const Text("Selecionar todos"),
                        //         const Spacer(),
                        //         Checkbox(
                        //           activeColor: primary,
                        //           value: store.allCustomers ?? false,
                        //           onChanged: (bool? value){
                        //             setState(() {                                      
                        //               store.allCustomers = value;
                        //             });
                        //           },
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        ...List.generate(
                          customersQuery.docs.length,
                          (index) {
                            DocumentSnapshot customerDoc = customersQuery.docs[index];
                            return CustomerCard(
                              customerDoc: customerDoc,
                            );
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
              right: store.visibleButton ? wXD(17, context) : wXD(-56, context),
              child: FloatingCircleButton(
                onTap: () async {
                  if(store.sendingCoupon){
                    if(store.customersSelected.isNotEmpty || store.allCustomers!){
                      await store.createCoupon(context);
                      setState(() {});
                    } else {
                      showToast("Selecione ao menos um cliente");
                    }
                  } else {
                    Modular.to.pushNamed('/create-coupon');
                  }
                },
                size: wXD(56, context),
                child: Icon(
                  store.sendingCoupon ?
                  Icons.send :
                  Icons.post_add,
                  size: wXD(30, context),
                  color: primary,
                ),
              ),
            );
          }),
            const Positioned(
              top: 0, 
              child: DefaultAppBar("Clientes", noPop: true),
            ),
          ],
        ),
      ),
    );
  }
}
