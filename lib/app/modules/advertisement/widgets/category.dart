import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class Category extends StatelessWidget {
  final String categoryId;
  final AdvertisementStore store = Modular.get();

  Category({
    Key? key,
    required this.categoryId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(categoryId)
                  .collection('options')
                  .orderBy('created_at', descending: false)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                          height: viewPaddingTop(context) + wXD(50, context)),
                      const LinearProgressIndicator(),
                    ],
                  );
                }

                QuerySnapshot options = snapshot.data!;

                // print('options.docs.length: ${options.docs.length}');

                return Column(
                  children: [
                    SizedBox(
                        height: viewPaddingTop(context) + wXD(50, context)),
                    ...List.generate(
                      options.docs.length,
                      (index) {
                        DocumentSnapshot optionDoc = options.docs[index];
                        // print('itemBuilder: $index, ${optionDoc['label']}');
                        return GestureDetector(
                          onTap: () {
                            store.editingAd
                                ? store.adEdit.option = optionDoc['label']
                                : store.setAdsOption(optionDoc['label']);
                            store.categoryValidateVisible = false;
                            Modular.to.pop();
                            Modular.to.pop();
                            // print("path: ${Modular.to.popUntil((p0) => false)}");
                            // Modular.to.pushNamedAndRemoveUntil(
                            //     '/advertisement/create-ads',
                            //     ModalRoute.withName(
                            //         '/advertisement/create-ads'));
                          },
                          child: Container(
                            width: maxWidth(context),
                            height: wXD(52, context),
                            margin: EdgeInsets.symmetric(
                                horizontal: wXD(23, context)),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: darkGrey.withOpacity(.2)))),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  optionDoc['label'],
                                  style: textFamily(
                                    color: primary,
                                    fontSize: 17,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: wXD(23, context),
                                  color: primary,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Observer(builder: (context) {
            return DefaultAppBar(
                store.editingAd ? store.adEdit.category : store.adsCategory);
          }),
        ],
      ),
    );
  }
}
