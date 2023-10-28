import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'activateAd_store.g.dart';

class ActivateAdStore = _ActivateAdStoreBase with _$ActivateAdStore;
abstract class _ActivateAdStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 

  @action
  Future<void> activateAd(String adsId) async{
    DocumentSnapshot adsDoc = await FirebaseFirestore.instance.collection('ads').doc(adsId).get();
    await adsDoc.reference.update({
      'status': 'ACTIVE',
    });
    FirebaseFirestore.instance.collection('sellers').doc(adsDoc['seller_id']).collection('ads').doc(adsId).update({
      "status": "ACTIVE"
    });
  }
}