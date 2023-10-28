import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../../shared/widgets/load_circular_overlay.dart';
part 'customers_store.g.dart';

class CustomersStore = _CustomersStoreBase with _$CustomersStore;
abstract class _CustomersStoreBase with Store {

  @observable
  num value = 0;
  @observable
  OverlayEntry? overlayRecharge;
  @observable
  OverlayEntry? overlayConfirm;
  @observable
  OverlayEntry? overlayLoad;
  @observable
  bool visibleButton = true;
  @observable
  bool sendingCoupon = false;
  @observable
  bool? allCustomers = false;
  @observable
  List customersSelected = [];
  @observable
  Map<String, dynamic> couponObj = {};

  @action
  void cleanCache(){
    visibleButton = true;
    sendingCoupon = false;
    allCustomers = false;
    customersSelected = [];
    couponObj = {};
    if(overlayLoad != null && overlayLoad!.mounted){
      overlayLoad!.remove();
    }
    overlayLoad = null;
  }

  @action
  Future<void> createCoupon(BuildContext context) async{
    overlayLoad = OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)?.insert(overlayLoad!);

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable("createCoupon");
    try {
      HttpsCallableResult result = await callable.call({
        "allCustomers": allCustomers,
        "couponObj": couponObj,
        "customerIdList": customersSelected,
      });
      if (kDebugMode) {
        print("result createCoupon: ${result.data}");
      }
      var resultData = result.data;
      if(resultData['status'] == ""){}
    } catch (e) {
      if (kDebugMode) {
        print("Error");
        print(e);
      }
    }

    cleanCache();
    
    overlayLoad!.remove();
  }

  @action
  void saveData({String? code, num? discountOff, num? percentOff, String? text, num? valueMinimum}){
    num? newPercentOff;
    if(percentOff != null){      
      newPercentOff = percentOff * 0.01;
    }
    couponObj = {
      "actived": false,
      "code": code,
      "created_at": null,
      "discount": discountOff,
      "guest_id": null,
      "percent_off": newPercentOff,
      "status": "VALID",
      "text": text,
      "type": "SUPPORT-CREATE",
      "used": false,
      "user_id": "scorefy",
      "value_minimum": valueMinimum,
    };

    sendingCoupon = true;
    Modular.to.pop();
  }


  @action
  Future<void> rechargeUser(String userId) async{
    if (kDebugMode) {
      print('rechargeUser: $userId - $value');
    }
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance.collection('customers').doc(userId).get();

    await customerDoc.reference.update({
      "account_balance": customerDoc['account_balance'] + value,
    });

    DocumentReference<Map<String, dynamic>> rechargeRef = await FirebaseFirestore.instance.collection('recharges').add({
      'created_at': FieldValue.serverTimestamp(),
      'user_id': userId,
      'value': value,
    });

    await rechargeRef.update({
      'id': rechargeRef.id,
    });

    DocumentSnapshot<Map<String, dynamic>> rechargeDoc = await rechargeRef.get();

    await customerDoc.reference.collection('recharges').doc(rechargeRef.id).set(rechargeDoc.data()!);

    DocumentReference<Map<String, dynamic>> transactionRef = await FirebaseFirestore.instance.collection('transactions').add({
      'created_at': FieldValue.serverTimestamp(),
      'customer_id': userId,
      'order_id': null,
      'payment_intent': null,
      'payment_method': 'RECHARGE',
      'seller_id': null,
      'status': 'CONCLUDED',
      'updated_at': FieldValue.serverTimestamp(),      
      'value': value,
    });

    await transactionRef.update({
      'id': transactionRef.id,
    });

    DocumentSnapshot<Map<String, dynamic>> transactionDoc = await transactionRef.get();

    await customerDoc.reference.collection('transactions').doc(transactionRef.id).set(transactionDoc.data()!);

    value = 0;
  }
}