// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomersStore on _CustomersStoreBase, Store {
  final _$valueAtom = Atom(name: '_CustomersStoreBase.value');

  @override
  num get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(num value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$overlayRechargeAtom =
      Atom(name: '_CustomersStoreBase.overlayRecharge');

  @override
  OverlayEntry? get overlayRecharge {
    _$overlayRechargeAtom.reportRead();
    return super.overlayRecharge;
  }

  @override
  set overlayRecharge(OverlayEntry? value) {
    _$overlayRechargeAtom.reportWrite(value, super.overlayRecharge, () {
      super.overlayRecharge = value;
    });
  }

  final _$overlayConfirmAtom = Atom(name: '_CustomersStoreBase.overlayConfirm');

  @override
  OverlayEntry? get overlayConfirm {
    _$overlayConfirmAtom.reportRead();
    return super.overlayConfirm;
  }

  @override
  set overlayConfirm(OverlayEntry? value) {
    _$overlayConfirmAtom.reportWrite(value, super.overlayConfirm, () {
      super.overlayConfirm = value;
    });
  }

  final _$overlayLoadAtom = Atom(name: '_CustomersStoreBase.overlayLoad');

  @override
  OverlayEntry? get overlayLoad {
    _$overlayLoadAtom.reportRead();
    return super.overlayLoad;
  }

  @override
  set overlayLoad(OverlayEntry? value) {
    _$overlayLoadAtom.reportWrite(value, super.overlayLoad, () {
      super.overlayLoad = value;
    });
  }

  final _$visibleButtonAtom = Atom(name: '_CustomersStoreBase.visibleButton');

  @override
  bool get visibleButton {
    _$visibleButtonAtom.reportRead();
    return super.visibleButton;
  }

  @override
  set visibleButton(bool value) {
    _$visibleButtonAtom.reportWrite(value, super.visibleButton, () {
      super.visibleButton = value;
    });
  }

  final _$sendingCouponAtom = Atom(name: '_CustomersStoreBase.sendingCoupon');

  @override
  bool get sendingCoupon {
    _$sendingCouponAtom.reportRead();
    return super.sendingCoupon;
  }

  @override
  set sendingCoupon(bool value) {
    _$sendingCouponAtom.reportWrite(value, super.sendingCoupon, () {
      super.sendingCoupon = value;
    });
  }

  final _$allCustomersAtom = Atom(name: '_CustomersStoreBase.allCustomers');

  @override
  bool? get allCustomers {
    _$allCustomersAtom.reportRead();
    return super.allCustomers;
  }

  @override
  set allCustomers(bool? value) {
    _$allCustomersAtom.reportWrite(value, super.allCustomers, () {
      super.allCustomers = value;
    });
  }

  final _$customersSelectedAtom =
      Atom(name: '_CustomersStoreBase.customersSelected');

  @override
  List<dynamic> get customersSelected {
    _$customersSelectedAtom.reportRead();
    return super.customersSelected;
  }

  @override
  set customersSelected(List<dynamic> value) {
    _$customersSelectedAtom.reportWrite(value, super.customersSelected, () {
      super.customersSelected = value;
    });
  }

  final _$couponObjAtom = Atom(name: '_CustomersStoreBase.couponObj');

  @override
  Map<String, dynamic> get couponObj {
    _$couponObjAtom.reportRead();
    return super.couponObj;
  }

  @override
  set couponObj(Map<String, dynamic> value) {
    _$couponObjAtom.reportWrite(value, super.couponObj, () {
      super.couponObj = value;
    });
  }

  final _$createCouponAsyncAction =
      AsyncAction('_CustomersStoreBase.createCoupon');

  @override
  Future<void> createCoupon(BuildContext context) {
    return _$createCouponAsyncAction.run(() => super.createCoupon(context));
  }

  final _$rechargeUserAsyncAction =
      AsyncAction('_CustomersStoreBase.rechargeUser');

  @override
  Future<void> rechargeUser(String userId) {
    return _$rechargeUserAsyncAction.run(() => super.rechargeUser(userId));
  }

  final _$_CustomersStoreBaseActionController =
      ActionController(name: '_CustomersStoreBase');

  @override
  void cleanCache() {
    final _$actionInfo = _$_CustomersStoreBaseActionController.startAction(
        name: '_CustomersStoreBase.cleanCache');
    try {
      return super.cleanCache();
    } finally {
      _$_CustomersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveData(
      {String? code,
      num? discountOff,
      num? percentOff,
      String? text,
      num? valueMinimum}) {
    final _$actionInfo = _$_CustomersStoreBaseActionController.startAction(
        name: '_CustomersStoreBase.saveData');
    try {
      return super.saveData(
          code: code,
          discountOff: discountOff,
          percentOff: percentOff,
          text: text,
          valueMinimum: valueMinimum);
    } finally {
      _$_CustomersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
overlayRecharge: ${overlayRecharge},
overlayConfirm: ${overlayConfirm},
overlayLoad: ${overlayLoad},
visibleButton: ${visibleButton},
sendingCoupon: ${sendingCoupon},
allCustomers: ${allCustomers},
customersSelected: ${customersSelected},
couponObj: ${couponObj}
    ''';
  }
}
