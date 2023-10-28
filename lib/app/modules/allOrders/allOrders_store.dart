import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../core/models/order_model.dart';
part 'allOrders_store.g.dart';

class AllOrdersStore = _AllOrdersStoreBase with _$AllOrdersStore;
abstract class _AllOrdersStoreBase with Store {

  @observable
  int filterIndex = -1;
  @observable
  int previousFilterIndex = -1;
  @observable
  DateTime nowDate = DateTime.now();
  @observable
  DateTime yesterdayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day -1);
  @observable
  Timestamp? startTimestamp;
  @observable
  Timestamp? endTimestamp;
  @observable
  DateTime? startDate;
  @observable
  DateTime? endDate;
  @observable
  OverlayEntry? filterOverlay;
  @observable
  bool removeOverlay = false;
  @observable
  bool filterBool = false;
  @observable
  TextEditingController textEditingController = TextEditingController();
  @observable
  String? filterText;

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

  @action
  insertOverlay(context, OverlayEntry _overlay) {
    filterOverlay = _overlay;
    Overlay.of(context)!.insert(filterOverlay!);
  }

  @action
  Future<void> filter() async{
    if(startDate != null){
      startTimestamp = Timestamp.fromDate(startDate!);
    }
    if(endDate != null){
      endTimestamp = Timestamp.fromDate(endDate!);
    }
    previousFilterIndex = filterIndex;
    if(filterIndex != 6){
      filterText = null;
    }
    if (kDebugMode) {
      print('textEditingController.text: ${textEditingController.text}');
    }
    if(textEditingController.text != ""){
      filterText = textEditingController.text;
    }
  }

  @action
  void filterAltered(int index){
    if(index != 6){
      textEditingController.clear();
      // filterText = null;
    } else {
      textEditingController.text = filterText!;
    }
    filterIndex = index;   
    List monthsWith30days = [
      4,
      6,
      9,
      11,
    ];
    List monthsWith31days = [
      1,
      3,
      5,
      7,
      8,
      10,
      12,
    ]; 
    switch (index) {
      case -1:
        previousFilterIndex = index;
        startDate = null;
        endDate = null;
        startTimestamp = null;
        endTimestamp = null;
        break;

      case 0:
        startDate = DateTime(nowDate.year, nowDate.month, nowDate.day, 0, 0, 0);
        endDate = DateTime(nowDate.year, nowDate.month, nowDate.day, 23, 59, 59);
        break;

      case 1:
        startDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 1, 0, 0, 0);
        endDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 1, 23, 59, 59);
        break;

      case 2:     
        if (kDebugMode) {
          print('nowDate.month: ${nowDate.month}');
        }
        if(nowDate.month == 2){
          startDate = DateTime(nowDate.year, nowDate.month, 1, 0, 0, 0);
          endDate = DateTime(nowDate.year, nowDate.month, 14, 23, 59, 59);
        }

        if(monthsWith30days.contains(nowDate.month)){
          startDate = DateTime(nowDate.year, nowDate.month, 1, 0, 0, 0);
          endDate = DateTime(nowDate.year, nowDate.month, 15, 23, 59, 59);
        }

        if(monthsWith31days.contains(nowDate.month)){
          startDate = DateTime(nowDate.year, nowDate.month, 1, 0, 0, 0);
          endDate = DateTime(nowDate.year, nowDate.month, 16, 12, 00, 00);
        }
        break;

      case 3:
        if (kDebugMode) {
          print('nowDate.month: ${nowDate.month}');
        }
        if(nowDate.month == 2){
          startDate = DateTime(nowDate.year, nowDate.month, 15, 0, 0, 0);
          endDate = DateTime(nowDate.year, nowDate.month, 28, 23, 59, 59);
        }

        if(monthsWith30days.contains(nowDate.month)){
          startDate = DateTime(nowDate.year, nowDate.month, 16, 0, 0, 0);
          endDate = DateTime(nowDate.year, nowDate.month, 30, 23, 59, 59);
        }

        if(monthsWith31days.contains(nowDate.month)){
          startDate = DateTime(nowDate.year, nowDate.month, 16, 12, 0, 0);
          endDate = DateTime(nowDate.year, nowDate.month, 31, 23, 59, 59);
        }
        break;

      case 4:
        int previousMonth = nowDate.month -1;
        if(previousMonth == 0){
          previousMonth = 12;
        }
        if (kDebugMode) {
          print('previousMonth: $previousMonth');
        }
        if(previousMonth == 2){
          startDate = DateTime(nowDate.year, previousMonth, 1, 0, 0, 0);
          endDate = DateTime(nowDate.year, previousMonth, 28, 23, 59, 59);
        }

        if(monthsWith30days.contains(previousMonth)){
          startDate = DateTime(nowDate.year, previousMonth, 1, 0, 0, 0);
          endDate = DateTime(nowDate.year, previousMonth, 30, 23, 59, 59);
        }

        if(monthsWith31days.contains(previousMonth)){
          startDate = DateTime(nowDate.year, previousMonth, 1, 0, 0, 0);
          endDate = DateTime(nowDate.year, previousMonth, 31, 23, 59, 59);
        }
        break;

      default:
        startDate = null;
        endDate = null;
        break;
    }
  }
}