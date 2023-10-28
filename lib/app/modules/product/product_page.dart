import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/core/models/ads_model.dart';
import 'package:delivery_support/app/modules/main/main_store.dart';
import 'package:delivery_support/app/modules/product/widgets/characteristics.dart';
import 'package:delivery_support/app/modules/product/widgets/store_informations.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_support/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'product_store.dart';
import 'widgets/item_data.dart';
import 'widgets/opinions.dart';

class ProductPage extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  final ProductStore store = Modular.get();

  ProductPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('product page: ${mainStore.adsId}');
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Stack(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ads')
                  .doc(mainStore.adsId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CenterLoadCircular();
                } else {
                  AdsModel model = AdsModel.fromDoc(snapshot.data!);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: viewPaddingTop(context) + wXD(50, context)),
                        ItemData(model: model, store: store),
                        Characteristics(model: model),
                        StoreInformations(
                          sellerId: model.sellerId,
                          adsId: model.id,
                          store: store,
                        ),
                        Opinions(model: model),
                      ],
                    ),
                  );
                }
              },
            ),
            const DefaultAppBar('Detalhes')
          ],
        ),
      ),
    );
  }
}
