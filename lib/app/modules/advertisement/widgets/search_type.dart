import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_support/app/shared/color_theme.dart';
import 'package:delivery_support/app/shared/utilities.dart';
import 'package:delivery_support/app/shared/widgets/center_load_circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../advertisement_store.dart';

class SearchType extends StatelessWidget {
  SearchType({Key? key}) : super(key: key);

  final AdvertisementStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      height: hXD(530, context),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      alignment: Alignment.topLeft,
      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection("types").get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CenterLoadCircular();
            }

            List<QueryDocumentSnapshot<Map<String, dynamic>>> types =
                snapshot.data!.docs;

            store.types = types;

            return StatefulBuilder(builder: (context, stfbState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: maxWidth(context),
                    padding: EdgeInsets.fromLTRB(
                      wXD(29, context),
                      wXD(24, context),
                      wXD(25, context),
                      wXD(11, context),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: darkGrey.withOpacity(.5)))),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: wXD(23, context),
                          color: primary,
                        ),
                        SizedBox(width: wXD(24, context)),
                        Expanded(
                          child: TextField(
                            onChanged: (txt) {
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  searchedTypes = [];

                              if (txt == "") {
                                searchedTypes = types;
                              } else {
                                types.forEach((type) {
                                  if (type["type"]
                                      .toString()
                                      .toLowerCase()
                                      .contains(txt.toLowerCase())) {
                                    searchedTypes.add(type);
                                  }
                                });
                              }
                              store.types = searchedTypes;
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Buscar tipo',
                              hintStyle: textFamily(
                                fontSize: 15,
                                color: darkGrey.withOpacity(.7),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(300),
                          onTap: () => store.setSearchType(false),
                          child: Icon(
                            Icons.close_rounded,
                            size: wXD(20, context),
                            color: Color(0xff555869).withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          top: wXD(23, context),
                          left: wXD(19, context),
                          right: wXD(19, context)),
                      child: Observer(builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: store.types
                              .map(
                                (e) => GestureDetector(
                                  onTap: () async {
                                    store.editingAd
                                        ? store.adEdit.type = e.get("type")
                                        : store.adsType = e.get("type");
                                    store.typeValidateVisible = false;
                                    store.setSearchType(false);
                                  },
                                  child: Container(
                                    width: maxWidth(context),
                                    padding: EdgeInsets.only(
                                        bottom: wXD(20, context)),
                                    child: Text(
                                      e.get("type"),
                                      style: textFamily(
                                        fontSize: 17,
                                        color: textTotalBlack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ),
                  ),
                ],
              );
            });
          }),
    );
  }
}
