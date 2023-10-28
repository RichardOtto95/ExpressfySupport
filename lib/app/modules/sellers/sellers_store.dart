import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/utilities.dart';
import '../../shared/widgets/load_circular_overlay.dart';

part 'sellers_store.g.dart';

class SellersStore = _SellersStoreBase with _$SellersStore;

abstract class _SellersStoreBase with Store {
  @observable
  bool addSeller = true;
  @observable
  bool avatarValidated = false;
  @observable
  File? avatar;
  @observable
  Map<String, dynamic> sellerCreateEdit = {};

  @action
  setAddSeller(bool _addSeller) => addSeller = _addSeller;

  @action
  getAddSeller() => addSeller;

  @action
  Future<void> activateAccount(String sellerId) async{
    await FirebaseFirestore.instance.collection('sellers').doc(sellerId).update({
      "status": "ACTIVE",
    });
  }

  @action
  Future saveProfile(context) async {
    if (avatar == null) {
      avatarValidated = true;
      showToast("Verifique os campos");
      return;
    } else {
      avatarValidated = false;
    }
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    Map<String, dynamic> _profileMap = sellerCreateEdit.cast();
    if (kDebugMode) {
      print("_profileMap: $_profileMap");
    }
    DocumentReference sellerRef = await FirebaseFirestore.instance.collection("sellers").add(_profileMap);

    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('sellers/${sellerRef.id}/avatar/$avatar');

    UploadTask uploadTask = firebaseStorageRef.putFile(avatar!);

    TaskSnapshot taskSnapshot = await uploadTask;

    String avatarURL = await taskSnapshot.ref.getDownloadURL();

    if (kDebugMode) {
      DocumentSnapshot selDoc = await sellerRef.get();
      print("avatarURL: $avatarURL");
      print('selDoc: ${selDoc.data()}');
    }
    try {
      await sellerRef.update({
        "avatar": avatarURL,
        "created_at": FieldValue.serverTimestamp(),
        "id": sellerRef.id,
        "status": "PREREGISTERED",
        "connected": true,
        "country": "Brasil",
        "new_messages": 0,
        "new_questions": 0,
        "new_ratings": 0,
        "new_support_messages": 0,
        "new_transactions": 0,
        "notification_enabled": true,
        "online": false,
        "phone": "+" + _profileMap["phone"],
        "seller_phone": _profileMap["seller_phone"] != null ? "+" + _profileMap["seller_phone"] : null,
      });
      if (kDebugMode) {
        DocumentSnapshot selDoc = await sellerRef.get();
        print('selDoc2: ${selDoc.data()}');
      }
      if (kDebugMode) {
        print('success');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('error');
        print(e);
      }
    }

    sellerCreateEdit.clear();
    avatar = null;
    avatarValidated = false;

    loadOverlay.remove();

    Modular.to.pop();
  }

  @action
  Future<void> editProfile(context) async {
    OverlayEntry loadOverlay;
    loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    if (avatar != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('sellers/${sellerCreateEdit["id"]}/avatar/$avatar');

      UploadTask uploadTask = firebaseStorageRef.putFile(avatar!);

      TaskSnapshot taskSnapshot = await uploadTask;

      final avatarURL = await taskSnapshot.ref.getDownloadURL();
      sellerCreateEdit["avatar"] = avatarURL;
    }

    String phone = sellerCreateEdit["phone"];

    if (!phone.contains("+")) {
      sellerCreateEdit["phone"] = "+" + sellerCreateEdit["phone"];
    }

    String? sellerPhone = sellerCreateEdit["seller_phone"];

    if (sellerPhone != null && !sellerPhone.contains("+")) {
      sellerCreateEdit["seller_phone"] = "+" + sellerCreateEdit["seller_phone"];
    }

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerCreateEdit["id"])
        .update(sellerCreateEdit);

    sellerCreateEdit.clear();
    avatar = null;
    Modular.to.pop();
    loadOverlay.remove();
  }

  cleanVars() {
    addSeller = true;
    avatarValidated = false;
    avatar = null;
    sellerCreateEdit = {};
  }
}
