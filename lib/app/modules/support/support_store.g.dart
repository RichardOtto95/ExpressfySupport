// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SupportStore on _SupportStoreBase, Store {
  final _$chatIdAtom = Atom(name: '_SupportStoreBase.chatId');

  @override
  String get chatId {
    _$chatIdAtom.reportRead();
    return super.chatId;
  }

  @override
  set chatId(String value) {
    _$chatIdAtom.reportWrite(value, super.chatId, () {
      super.chatId = value;
    });
  }

  final _$receiverNameAtom = Atom(name: '_SupportStoreBase.receiverName');

  @override
  String get receiverName {
    _$receiverNameAtom.reportRead();
    return super.receiverName;
  }

  @override
  set receiverName(String value) {
    _$receiverNameAtom.reportWrite(value, super.receiverName, () {
      super.receiverName = value;
    });
  }

  final _$recCollAtom = Atom(name: '_SupportStoreBase.recColl');

  @override
  String get recColl {
    _$recCollAtom.reportRead();
    return super.recColl;
  }

  @override
  set recColl(String value) {
    _$recCollAtom.reportWrite(value, super.recColl, () {
      super.recColl = value;
    });
  }

  final _$textAtom = Atom(name: '_SupportStoreBase.text');

  @override
  String get text {
    _$textAtom.reportRead();
    return super.text;
  }

  @override
  set text(String value) {
    _$textAtom.reportWrite(value, super.text, () {
      super.text = value;
    });
  }

  final _$searchTextAtom = Atom(name: '_SupportStoreBase.searchText');

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  final _$customerAtom = Atom(name: '_SupportStoreBase.customer');

  @override
  Customer? get customer {
    _$customerAtom.reportRead();
    return super.customer;
  }

  @override
  set customer(Customer? value) {
    _$customerAtom.reportWrite(value, super.customer, () {
      super.customer = value;
    });
  }

  final _$sellerAtom = Atom(name: '_SupportStoreBase.seller');

  @override
  Seller? get seller {
    _$sellerAtom.reportRead();
    return super.seller;
  }

  @override
  set seller(Seller? value) {
    _$sellerAtom.reportWrite(value, super.seller, () {
      super.seller = value;
    });
  }

  final _$agentAtom = Atom(name: '_SupportStoreBase.agent');

  @override
  Agent? get agent {
    _$agentAtom.reportRead();
    return super.agent;
  }

  @override
  set agent(Agent? value) {
    _$agentAtom.reportWrite(value, super.agent, () {
      super.agent = value;
    });
  }

  final _$textChatControllerAtom =
      Atom(name: '_SupportStoreBase.textChatController');

  @override
  TextEditingController? get textChatController {
    _$textChatControllerAtom.reportRead();
    return super.textChatController;
  }

  @override
  set textChatController(TextEditingController? value) {
    _$textChatControllerAtom.reportWrite(value, super.textChatController, () {
      super.textChatController = value;
    });
  }

  final _$messageIdsAtom = Atom(name: '_SupportStoreBase.messageIds');

  @override
  List<String> get messageIds {
    _$messageIdsAtom.reportRead();
    return super.messageIds;
  }

  @override
  set messageIds(List<String> value) {
    _$messageIdsAtom.reportWrite(value, super.messageIds, () {
      super.messageIds = value;
    });
  }

  final _$cameraImageAtom = Atom(name: '_SupportStoreBase.cameraImage');

  @override
  File? get cameraImage {
    _$cameraImageAtom.reportRead();
    return super.cameraImage;
  }

  @override
  set cameraImage(File? value) {
    _$cameraImageAtom.reportWrite(value, super.cameraImage, () {
      super.cameraImage = value;
    });
  }

  final _$imagesAtom = Atom(name: '_SupportStoreBase.images');

  @override
  ObservableList<File> get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableList<File> value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  final _$imagesPageAtom = Atom(name: '_SupportStoreBase.imagesPage');

  @override
  int get imagesPage {
    _$imagesPageAtom.reportRead();
    return super.imagesPage;
  }

  @override
  set imagesPage(int value) {
    _$imagesPageAtom.reportWrite(value, super.imagesPage, () {
      super.imagesPage = value;
    });
  }

  final _$searchedChatsAtom = Atom(name: '_SupportStoreBase.searchedChats');

  @override
  List<DocumentSnapshot<Map<String, dynamic>>>? get searchedChats {
    _$searchedChatsAtom.reportRead();
    return super.searchedChats;
  }

  @override
  set searchedChats(List<DocumentSnapshot<Map<String, dynamic>>>? value) {
    _$searchedChatsAtom.reportWrite(value, super.searchedChats, () {
      super.searchedChats = value;
    });
  }

  final _$searchedSupportAtom = Atom(name: '_SupportStoreBase.searchedSupport');

  @override
  List<SearchMessage>? get searchedSupport {
    _$searchedSupportAtom.reportRead();
    return super.searchedSupport;
  }

  @override
  set searchedSupport(List<SearchMessage>? value) {
    _$searchedSupportAtom.reportWrite(value, super.searchedSupport, () {
      super.searchedSupport = value;
    });
  }

  final _$messagesAtom = Atom(name: '_SupportStoreBase.messages');

  @override
  ObservableList<Message> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<Message> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$messagesSubscriptionAtom =
      Atom(name: '_SupportStoreBase.messagesSubscription');

  @override
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      get messagesSubscription {
    _$messagesSubscriptionAtom.reportRead();
    return super.messagesSubscription;
  }

  @override
  set messagesSubscription(
      StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? value) {
    _$messagesSubscriptionAtom.reportWrite(value, super.messagesSubscription,
        () {
      super.messagesSubscription = value;
    });
  }

  final _$searchSupportAsyncAction =
      AsyncAction('_SupportStoreBase.searchSupport');

  @override
  Future searchSupport(
      String _text, QuerySnapshot<Map<String, dynamic>> chatQue) {
    return _$searchSupportAsyncAction
        .run(() => super.searchSupport(_text, chatQue));
  }

  final _$loadChatDataAsyncAction =
      AsyncAction('_SupportStoreBase.loadChatData');

  @override
  Future<String> loadChatData(String receiverId, String receiverCollection) {
    return _$loadChatDataAsyncAction
        .run(() => super.loadChatData(receiverId, receiverCollection));
  }

  final _$sendMessageAsyncAction = AsyncAction('_SupportStoreBase.sendMessage');

  @override
  Future<dynamic> sendMessage() {
    return _$sendMessageAsyncAction.run(() => super.sendMessage());
  }

  final _$sendImageAsyncAction = AsyncAction('_SupportStoreBase.sendImage');

  @override
  Future<dynamic> sendImage(dynamic context) {
    return _$sendImageAsyncAction.run(() => super.sendImage(context));
  }

  final _$_SupportStoreBaseActionController =
      ActionController(name: '_SupportStoreBase');

  @override
  void removeImage() {
    final _$actionInfo = _$_SupportStoreBaseActionController.startAction(
        name: '_SupportStoreBase.removeImage');
    try {
      return super.removeImage();
    } finally {
      _$_SupportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cancelImages() {
    final _$actionInfo = _$_SupportStoreBaseActionController.startAction(
        name: '_SupportStoreBase.cancelImages');
    try {
      return super.cancelImages();
    } finally {
      _$_SupportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void disposeChat() {
    final _$actionInfo = _$_SupportStoreBaseActionController.startAction(
        name: '_SupportStoreBase.disposeChat');
    try {
      return super.disposeChat();
    } finally {
      _$_SupportStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chatId: ${chatId},
receiverName: ${receiverName},
recColl: ${recColl},
text: ${text},
searchText: ${searchText},
customer: ${customer},
seller: ${seller},
agent: ${agent},
textChatController: ${textChatController},
messageIds: ${messageIds},
cameraImage: ${cameraImage},
images: ${images},
imagesPage: ${imagesPage},
searchedChats: ${searchedChats},
searchedSupport: ${searchedSupport},
messages: ${messages},
messagesSubscription: ${messagesSubscription}
    ''';
  }
}
