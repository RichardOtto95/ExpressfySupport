// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellers_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SellersStore on _SellersStoreBase, Store {
  final _$addSellerAtom = Atom(name: '_SellersStoreBase.addSeller');

  @override
  bool get addSeller {
    _$addSellerAtom.reportRead();
    return super.addSeller;
  }

  @override
  set addSeller(bool value) {
    _$addSellerAtom.reportWrite(value, super.addSeller, () {
      super.addSeller = value;
    });
  }

  final _$avatarValidatedAtom = Atom(name: '_SellersStoreBase.avatarValidated');

  @override
  bool get avatarValidated {
    _$avatarValidatedAtom.reportRead();
    return super.avatarValidated;
  }

  @override
  set avatarValidated(bool value) {
    _$avatarValidatedAtom.reportWrite(value, super.avatarValidated, () {
      super.avatarValidated = value;
    });
  }

  final _$avatarAtom = Atom(name: '_SellersStoreBase.avatar');

  @override
  File? get avatar {
    _$avatarAtom.reportRead();
    return super.avatar;
  }

  @override
  set avatar(File? value) {
    _$avatarAtom.reportWrite(value, super.avatar, () {
      super.avatar = value;
    });
  }

  final _$sellerCreateEditAtom =
      Atom(name: '_SellersStoreBase.sellerCreateEdit');

  @override
  Map<String, dynamic> get sellerCreateEdit {
    _$sellerCreateEditAtom.reportRead();
    return super.sellerCreateEdit;
  }

  @override
  set sellerCreateEdit(Map<String, dynamic> value) {
    _$sellerCreateEditAtom.reportWrite(value, super.sellerCreateEdit, () {
      super.sellerCreateEdit = value;
    });
  }

  final _$activateAccountAsyncAction =
      AsyncAction('_SellersStoreBase.activateAccount');

  @override
  Future<void> activateAccount(String sellerId) {
    return _$activateAccountAsyncAction
        .run(() => super.activateAccount(sellerId));
  }

  final _$saveProfileAsyncAction = AsyncAction('_SellersStoreBase.saveProfile');

  @override
  Future<dynamic> saveProfile(dynamic context) {
    return _$saveProfileAsyncAction.run(() => super.saveProfile(context));
  }

  final _$editProfileAsyncAction = AsyncAction('_SellersStoreBase.editProfile');

  @override
  Future<void> editProfile(dynamic context) {
    return _$editProfileAsyncAction.run(() => super.editProfile(context));
  }

  final _$_SellersStoreBaseActionController =
      ActionController(name: '_SellersStoreBase');

  @override
  dynamic setAddSeller(bool _addSeller) {
    final _$actionInfo = _$_SellersStoreBaseActionController.startAction(
        name: '_SellersStoreBase.setAddSeller');
    try {
      return super.setAddSeller(_addSeller);
    } finally {
      _$_SellersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getAddSeller() {
    final _$actionInfo = _$_SellersStoreBaseActionController.startAction(
        name: '_SellersStoreBase.getAddSeller');
    try {
      return super.getAddSeller();
    } finally {
      _$_SellersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
addSeller: ${addSeller},
avatarValidated: ${avatarValidated},
avatar: ${avatar},
sellerCreateEdit: ${sellerCreateEdit}
    ''';
  }
}
