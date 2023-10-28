import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_support/app/modules/activate_ad/activateAd_store.dart';
import 'package:flutter/material.dart';

import '../../shared/utilities.dart';
import '../../shared/widgets/center_load_circular.dart';
import '../../shared/widgets/default_app_bar.dart';
import '../main/main_store.dart';
import 'widgets/ads_card.dart';

class ActivateAdPage extends StatefulWidget {
  const ActivateAdPage({Key? key}) : super(key: key);
  @override
  ActivateAdPageState createState() => ActivateAdPageState();
}

class ActivateAdPageState extends State<ActivateAdPage> {
  final ActivateAdStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final ScrollController scrollController = ScrollController();
  int limit = 25;
  bool hasMore = true;

  @override
  void initState() {
    scrollController.addListener(() {
      // print('limit: $limit - $hasMore');
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 150) && hasMore) {
        setState(() {
          limit += 25;
        });
      }
      // if(){}
      // print("ScrollDirection: ${}");
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: maxHeight(context),
            width: maxWidth(context),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                  .collection("ads")
                  .where("status", isEqualTo: "UNDER-ANALYSIS")
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
                  QuerySnapshot adsQuery = snapshot.data!;
                  hasMore = adsQuery.docs.length == limit;
                  // if (kDebugMode) {
                  //   print('adsQuery.docs.length: ${adsQuery.docs.length}');
                  // }
                  return Listener(
                    onPointerDown: (event) {
                      mainStore.removeGlobalOverlay();
                    },
                    child: Column(children: [
                      SizedBox(
                          height: viewPaddingTop(context) + wXD(50, context)),
                      ...List.generate(
                        adsQuery.docs.length,
                        (index) {
                          DocumentSnapshot adsDoc = adsQuery.docs[index];
                          return AdsCard(
                            adsDoc: adsDoc,
                          );
                        },
                      ),
                      hasMore ? const CircularProgressIndicator(color: primary,) : Container(),
                      SizedBox(height: wXD(50, context)),
                    ]),
                  );
                },
              ),
            ),
          ),
          const Positioned(
            top: 0, 
            child: DefaultAppBar("Anúncios por ativar", noPop: true),
          ),
        ],
      ),
    );
  }
}
