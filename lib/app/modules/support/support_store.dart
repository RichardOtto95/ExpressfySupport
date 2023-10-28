import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';
import '../../core/models/agent_model.dart';
import '../../core/models/customer_model.dart';
import '../../core/models/message_model.dart';
import '../../core/models/seller_model.dart';
import '../../shared/widgets/load_circular_overlay.dart';
part 'support_store.g.dart';

class SupportStore = _SupportStoreBase with _$SupportStore;

abstract class _SupportStoreBase with Store {
  @observable
  String chatId = "";
  @observable
  String receiverName = "";
  @observable
  String recColl = "";
  @observable
  String text = "";
  @observable
  String searchText = "";
  @observable
  Customer? customer;
  @observable
  Seller? seller;
  @observable
  Agent? agent;
  @observable
  TextEditingController? textChatController;
  @observable
  List<String> messageIds = [];
  @observable
  File? cameraImage;
  @observable
  ObservableList<File> images = <File>[].asObservable();
  @observable
  int imagesPage = 0;
  // @observable
  // bool imagesBool = false;
  @observable
  List<DocumentSnapshot<Map<String, dynamic>>>? searchedChats;
  @observable
  List<SearchMessage>? searchedSupport;
  @observable
  ObservableList<Message> messages = <Message>[].asObservable();
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? messagesSubscription;

  bool getShowUserData(int i) => messages[i].author != messages[i - 1].author;

  bool getIsAuthor(int i) => messages[i].author == "support";

  @action
  void removeImage() {
    images.removeAt(imagesPage);
    if (imagesPage == images.length && imagesPage != 0) {
      imagesPage = images.length - 1;
    }
    print(imagesPage);
  }

  @action
  void cancelImages() {
    images.clear();
    imagesPage = 0;
    cameraImage = null;
  }

  @action
  searchSupport(
    String _text,
    QuerySnapshot<Map<String, dynamic>> chatQue,
  ) async {
    // print("searchSupport: $searchSupport");
    searchText = _text;
    if (_text == "") {
      searchedChats = null;
      searchedSupport = null;
      return;
    }

    List<DocumentSnapshot<Map<String, dynamic>>> _chats = [];
    List<SearchMessage> _messages = [];

    for (DocumentSnapshot<Map<String, dynamic>> chatDoc in chatQue.docs) {
      String receiverId = chatDoc["user_id"];
      String receiverCollection =
          chatDoc["user_collection"].toString().toLowerCase();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(chatDoc["user_collection"].toString().toLowerCase())
          .doc(chatDoc["user_id"])
          .get();
      if (userDoc["username"]
          .toString()
          .toLowerCase()
          .contains(_text.toLowerCase())) {
        _chats.add(chatDoc);
      }

      final mesQue = await chatDoc.reference.collection("messages").get();

      for (DocumentSnapshot mesDoc in mesQue.docs) {
        if (mesDoc["text"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _messages.add(
            SearchMessage(
              Message.fromDoc(mesDoc),
              mesDoc["author"] == "support" ? "Você" : userDoc["username"],
              receiverId,
              receiverCollection,
            ),
          );
        }
      }
    }

    searchedChats = _chats;
    searchedSupport = _messages;
  }

  @action
  Future<String> loadChatData(
    String receiverId,
    String receiverCollection,
  ) async {
    recColl = receiverCollection;
    QuerySnapshot chatQue;

    DocumentSnapshot recDoc = await FirebaseFirestore.instance
        .collection(receiverCollection)
        .doc(receiverId)
        .get();

    chatQue = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: receiverId)
        .where("user_collection", isEqualTo: receiverCollection.toUpperCase())
        .get();

    if (receiverCollection == "sellers") {
      seller = Seller.fromDoc(recDoc);
    } else if (receiverCollection == "customers") {
      customer = Customer.fromDoc(recDoc);
    } else if (receiverCollection == "agents") {
      agent = Agent.fromDoc(recDoc);
    }

    if (chatQue.docs.isEmpty) {
      // await createSupport(cusDoc, recDoc);
      return "Erro";
    }

    final chatDoc = chatQue.docs.first;

    chatId = chatDoc.id;

    final chatStream = chatDoc.reference
        .collection("messages")
        .orderBy("created_at")
        .snapshots();

    messagesSubscription = chatStream.listen((event) async {
      for (var element in event.docChanges) {
        if (!messageIds.contains(element.doc.id) &&
            element.doc["created_at"] != null) {
          DateTime lastDate = messages.isEmpty
              ? DateTime(2000)
              : messages.last.createdAt.toDate();
          DateTime thisDate = element.doc["created_at"].toDate();
          if (lastDate.toString().substring(0, 11) !=
                  thisDate.toString().substring(0, 11) ||
              messages.isEmpty) {
            messages.insert(
                messages.length,
                Message(
                  author: "",
                  text: "",
                  isDaySeparator: true,
                  daySeparator: [thisDate],
                ));
          }
          messages.insert(messages.length, Message.fromDoc(element.doc));
          messageIds.add(element.doc.id);
        }
      }
      await FirebaseFirestore.instance
          .collection("supports")
          .doc(chatId)
          .update({"support_notification": 0});
    });
    return recDoc["username"];
  }

  @action
  Future sendMessage() async {
    if (text == "") return;
    textChatController!.clear();
    String _text = text;
    text = "";

    DocumentSnapshot<Map<String, dynamic>> chatDoc = await FirebaseFirestore
        .instance
        .collection("supports")
        .doc(chatId)
        .get();

    final tstRef = chatDoc.reference.collection("messages").doc();

    await tstRef.set({
      "created_at": FieldValue.serverTimestamp(),
      "author": "support",
      "text": _text,
      "id": tstRef.id,
      "file": null,
      "file_type": null,
    });

    Map<String, dynamic> chatUpd = {
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": _text,
    };

    await FirebaseFirestore.instance
        .collection(chatDoc.get("user_collection").toString().toLowerCase())
        .doc(chatDoc.get("user_id"))
        .update({"new_support_messages": FieldValue.increment(1)});

    await chatDoc.reference.update(chatUpd);
  }

  @action
  Future sendImage(context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    List<File> _images = cameraImage == null ? images : [cameraImage!];
    DocumentSnapshot<Map<String, dynamic>> chatDoc = await FirebaseFirestore
        .instance
        .collection("supports")
        .doc(chatId)
        .get();

    for (int i = 0; i < _images.length; i++) {
      final msgRef = chatDoc.reference.collection("messages").doc();

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('supports/${chatDoc.id}/${msgRef.id}');
      UploadTask uploadTask = firebaseStorageRef.putFile(_images[i]);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageString = await taskSnapshot.ref.getDownloadURL();

      String? mimeType = lookupMimeType(_images[i].path);

      await msgRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "author": "support",
        "text": null,
        "id": msgRef.id,
        "file": imageString,
        "file_type": mimeType,
      });
    }

    Map<String, dynamic> chatUpd = {
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": "[imagem]",
    };

    await FirebaseFirestore.instance
        .collection(chatDoc.get("user_collection").toString().toLowerCase())
        .doc(chatDoc.get("user_id"))
        .update({"new_support_messages": FieldValue.increment(_images.length)});

    await chatDoc.reference.update(chatUpd);

    // imagesBool = false;
    cameraImage = null;
    await Future.delayed(Duration(milliseconds: 500), () => images.clear());
    loadOverlay.remove();
  }

  @action
  void disposeChat() {
    print("dispose do chat");
    textChatController!.dispose();
    if (messagesSubscription != null) messagesSubscription!.cancel();
    messagesSubscription = null;
    seller = null;
    agent = null;
    messages.clear();
    messageIds.clear();
  }

  void disposeSupport() {
    searchedChats = null;
    searchedSupport = null;
  }
}
