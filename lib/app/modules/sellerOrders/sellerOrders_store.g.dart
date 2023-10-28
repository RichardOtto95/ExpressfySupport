// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerOrders_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SellerOrdersStore on _SellerOrdersStoreBase, Store {
  final _$valueAtom = Atom(name: '_SellerOrdersStoreBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$wasPaidAsyncAction = AsyncAction('_SellerOrdersStoreBase.wasPaid');

  @override
  Future<void> wasPaid(Order model) {
    return _$wasPaidAsyncAction.run(() => super.wasPaid(model));
  }

  final _$_SellerOrdersStoreBaseActionController =
      ActionController(name: '_SellerOrdersStoreBase');

  @override
  void increment() {
    final _$actionInfo = _$_SellerOrdersStoreBaseActionController.startAction(
        name: '_SellerOrdersStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_SellerOrdersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
