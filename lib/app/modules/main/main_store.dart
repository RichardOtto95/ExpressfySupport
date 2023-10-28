import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  @observable
  bool visibleNav = true;
  @observable
  bool paginateEnable = true;
  @observable
  int page = 0;
  @observable
  String? adsId;
  @observable
  PageController pageController = PageController();
  @observable
  OverlayEntry? globalOverlay;

  @action
  Future<void> saveTokenId() async{
    DocumentSnapshot infoDoc = (await FirebaseFirestore.instance.collection('info').get()).docs.first;
    String? tokenString = await FirebaseMessaging.instance.getToken();
    if(tokenString != null) {
      await infoDoc.reference.update({
        "token_id_support": FieldValue.arrayUnion([tokenString]),
      });
    }

  }

  @action
  setVisibleNav(bool _visibleNav) => visibleNav = _visibleNav;
  @action
  setAdsId(String _adsId) => adsId = _adsId;

  @action
  Future<void> setPage(int _page) async {
    removeGlobalOverlay();

    if (paginateEnable) {
      await pageController.animateToPage(
        _page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
      page = _page;
    }
  }

  @action
  removeGlobalOverlay() {
    if (globalOverlay != null) {
      globalOverlay!.remove();
      globalOverlay = null;
    }
  }

  @action
  setGlobalOverlay(OverlayEntry _globalOverlay, context) {
    if (globalOverlay == null) {
      globalOverlay = _globalOverlay;
      Overlay.of(context)?.insert(globalOverlay ?? _globalOverlay);
    } else {
      globalOverlay?.dispose();
      globalOverlay = _globalOverlay;
      Overlay.of(context)?.insert(globalOverlay ?? _globalOverlay);
    }
  }
}
