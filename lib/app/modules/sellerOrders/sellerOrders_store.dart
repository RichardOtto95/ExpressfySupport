import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../core/models/order_model.dart';

part 'sellerOrders_store.g.dart';

class SellerOrdersStore = _SellerOrdersStoreBase with _$SellerOrdersStore;
abstract class _SellerOrdersStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 

  @action
  Future<void> wasPaid(Order model) async{
    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance.collection('sellers').doc(model.sellerId).get();
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance.collection('customers').doc(model.customerId).get();
    String? transactionId;

    QuerySnapshot transactionsQuery = await FirebaseFirestore.instance.collection('transactions').where('order_id', isEqualTo: model.id).get();
    if(transactionsQuery.docs.isNotEmpty){
      DocumentSnapshot transactionDoc = transactionsQuery.docs.first;
      transactionId = transactionDoc.id;
      await transactionDoc.reference.update({
        'status': 'PAID',
      });
    }

    await FirebaseFirestore.instance.collection('orders').doc(model.id).update({
      'paid': true,
    });

    await sellerDoc.reference.collection('orders').doc(model.id).update({
      'paid': true,
    });    

    await customerDoc.reference.collection('orders').doc(model.id).update({
      'paid': true,
    });

    if(transactionId != null){
      await sellerDoc.reference.collection('transactions').doc(transactionId).update({
        'status': 'PAID',
      });
      
      await customerDoc.reference.collection('transactions').doc(transactionId).update({
        'status': 'PAID',
      });
    }

    if(model.agentId != null){
      await FirebaseFirestore.instance.collection('agents/${model.agentId}/orders').doc(model.id).update({
        'paid': true,
      });
    }
  } 
}