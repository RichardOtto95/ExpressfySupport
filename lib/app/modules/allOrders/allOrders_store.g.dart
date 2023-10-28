// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allOrders_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AllOrdersStore on _AllOrdersStoreBase, Store {
  final _$filterIndexAtom = Atom(name: '_AllOrdersStoreBase.filterIndex');

  @override
  int get filterIndex {
    _$filterIndexAtom.reportRead();
    return super.filterIndex;
  }

  @override
  set filterIndex(int value) {
    _$filterIndexAtom.reportWrite(value, super.filterIndex, () {
      super.filterIndex = value;
    });
  }

  final _$previousFilterIndexAtom =
      Atom(name: '_AllOrdersStoreBase.previousFilterIndex');

  @override
  int get previousFilterIndex {
    _$previousFilterIndexAtom.reportRead();
    return super.previousFilterIndex;
  }

  @override
  set previousFilterIndex(int value) {
    _$previousFilterIndexAtom.reportWrite(value, super.previousFilterIndex, () {
      super.previousFilterIndex = value;
    });
  }

  final _$nowDateAtom = Atom(name: '_AllOrdersStoreBase.nowDate');

  @override
  DateTime get nowDate {
    _$nowDateAtom.reportRead();
    return super.nowDate;
  }

  @override
  set nowDate(DateTime value) {
    _$nowDateAtom.reportWrite(value, super.nowDate, () {
      super.nowDate = value;
    });
  }

  final _$yesterdayDateAtom = Atom(name: '_AllOrdersStoreBase.yesterdayDate');

  @override
  DateTime get yesterdayDate {
    _$yesterdayDateAtom.reportRead();
    return super.yesterdayDate;
  }

  @override
  set yesterdayDate(DateTime value) {
    _$yesterdayDateAtom.reportWrite(value, super.yesterdayDate, () {
      super.yesterdayDate = value;
    });
  }

  final _$startTimestampAtom = Atom(name: '_AllOrdersStoreBase.startTimestamp');

  @override
  Timestamp? get startTimestamp {
    _$startTimestampAtom.reportRead();
    return super.startTimestamp;
  }

  @override
  set startTimestamp(Timestamp? value) {
    _$startTimestampAtom.reportWrite(value, super.startTimestamp, () {
      super.startTimestamp = value;
    });
  }

  final _$endTimestampAtom = Atom(name: '_AllOrdersStoreBase.endTimestamp');

  @override
  Timestamp? get endTimestamp {
    _$endTimestampAtom.reportRead();
    return super.endTimestamp;
  }

  @override
  set endTimestamp(Timestamp? value) {
    _$endTimestampAtom.reportWrite(value, super.endTimestamp, () {
      super.endTimestamp = value;
    });
  }

  final _$startDateAtom = Atom(name: '_AllOrdersStoreBase.startDate');

  @override
  DateTime? get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(DateTime? value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  final _$endDateAtom = Atom(name: '_AllOrdersStoreBase.endDate');

  @override
  DateTime? get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(DateTime? value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  final _$filterOverlayAtom = Atom(name: '_AllOrdersStoreBase.filterOverlay');

  @override
  OverlayEntry? get filterOverlay {
    _$filterOverlayAtom.reportRead();
    return super.filterOverlay;
  }

  @override
  set filterOverlay(OverlayEntry? value) {
    _$filterOverlayAtom.reportWrite(value, super.filterOverlay, () {
      super.filterOverlay = value;
    });
  }

  final _$removeOverlayAtom = Atom(name: '_AllOrdersStoreBase.removeOverlay');

  @override
  bool get removeOverlay {
    _$removeOverlayAtom.reportRead();
    return super.removeOverlay;
  }

  @override
  set removeOverlay(bool value) {
    _$removeOverlayAtom.reportWrite(value, super.removeOverlay, () {
      super.removeOverlay = value;
    });
  }

  final _$filterBoolAtom = Atom(name: '_AllOrdersStoreBase.filterBool');

  @override
  bool get filterBool {
    _$filterBoolAtom.reportRead();
    return super.filterBool;
  }

  @override
  set filterBool(bool value) {
    _$filterBoolAtom.reportWrite(value, super.filterBool, () {
      super.filterBool = value;
    });
  }

  final _$textEditingControllerAtom =
      Atom(name: '_AllOrdersStoreBase.textEditingController');

  @override
  TextEditingController get textEditingController {
    _$textEditingControllerAtom.reportRead();
    return super.textEditingController;
  }

  @override
  set textEditingController(TextEditingController value) {
    _$textEditingControllerAtom.reportWrite(value, super.textEditingController,
        () {
      super.textEditingController = value;
    });
  }

  final _$filterTextAtom = Atom(name: '_AllOrdersStoreBase.filterText');

  @override
  String? get filterText {
    _$filterTextAtom.reportRead();
    return super.filterText;
  }

  @override
  set filterText(String? value) {
    _$filterTextAtom.reportWrite(value, super.filterText, () {
      super.filterText = value;
    });
  }

  final _$wasPaidAsyncAction = AsyncAction('_AllOrdersStoreBase.wasPaid');

  @override
  Future<void> wasPaid(Order model) {
    return _$wasPaidAsyncAction.run(() => super.wasPaid(model));
  }

  final _$filterAsyncAction = AsyncAction('_AllOrdersStoreBase.filter');

  @override
  Future<void> filter() {
    return _$filterAsyncAction.run(() => super.filter());
  }

  final _$_AllOrdersStoreBaseActionController =
      ActionController(name: '_AllOrdersStoreBase');

  @override
  dynamic insertOverlay(dynamic context, OverlayEntry _overlay) {
    final _$actionInfo = _$_AllOrdersStoreBaseActionController.startAction(
        name: '_AllOrdersStoreBase.insertOverlay');
    try {
      return super.insertOverlay(context, _overlay);
    } finally {
      _$_AllOrdersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void filterAltered(int index) {
    final _$actionInfo = _$_AllOrdersStoreBaseActionController.startAction(
        name: '_AllOrdersStoreBase.filterAltered');
    try {
      return super.filterAltered(index);
    } finally {
      _$_AllOrdersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filterIndex: ${filterIndex},
previousFilterIndex: ${previousFilterIndex},
nowDate: ${nowDate},
yesterdayDate: ${yesterdayDate},
startTimestamp: ${startTimestamp},
endTimestamp: ${endTimestamp},
startDate: ${startDate},
endDate: ${endDate},
filterOverlay: ${filterOverlay},
removeOverlay: ${removeOverlay},
filterBool: ${filterBool},
textEditingController: ${textEditingController},
filterText: ${filterText}
    ''';
  }
}
