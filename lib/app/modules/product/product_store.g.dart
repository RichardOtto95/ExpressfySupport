// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductStore on _ProductStoreBase, Store {
  final _$imageIndexAtom = Atom(name: '_ProductStoreBase.imageIndex');

  @override
  int get imageIndex {
    _$imageIndexAtom.reportRead();
    return super.imageIndex;
  }

  @override
  set imageIndex(int value) {
    _$imageIndexAtom.reportWrite(value, super.imageIndex, () {
      super.imageIndex = value;
    });
  }

  final _$ratingsAtom = Atom(name: '_ProductStoreBase.ratings');

  @override
  ObservableList<DocumentSnapshot<Object?>> get ratings {
    _$ratingsAtom.reportRead();
    return super.ratings;
  }

  @override
  set ratings(ObservableList<DocumentSnapshot<Object?>> value) {
    _$ratingsAtom.reportWrite(value, super.ratings, () {
      super.ratings = value;
    });
  }

  final _$shareAsyncAction = AsyncAction('_ProductStoreBase.share');

  @override
  Future<void> share() {
    return _$shareAsyncAction.run(() => super.share());
  }

  final _$_ProductStoreBaseActionController =
      ActionController(name: '_ProductStoreBase');

  @override
  void setImageIndex(dynamic _imageIndex) {
    final _$actionInfo = _$_ProductStoreBaseActionController.startAction(
        name: '_ProductStoreBase.setImageIndex');
    try {
      return super.setImageIndex(_imageIndex);
    } finally {
      _$_ProductStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
imageIndex: ${imageIndex},
ratings: ${ratings}
    ''';
  }
}
