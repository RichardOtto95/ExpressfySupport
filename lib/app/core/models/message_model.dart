import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String author;
  final dynamic createdAt;
  final String? file;
  final String? fileType;
  final String? id;
  final String? text;

  final bool isDaySeparator;
  final List<DateTime> daySeparator;

  Message({
    this.isDaySeparator = false,
    this.daySeparator = const [],
    this.file,
    this.fileType,
    this.createdAt,
    required this.author,
    required this.text,
    this.id,
  });

  factory Message.fromDoc(DocumentSnapshot doc) => Message(
        author: doc["author"],
        createdAt: doc["created_at"],
        text: doc["text"],
        id: doc["id"],
        file: doc["file"],
        fileType: doc["file_type"],
      );

  Map<String, dynamic> toJson() => {
        "author": author,
        "created_at": createdAt,
        "text": text,
        "id": id,
        "file": file,
        "file_type": fileType,
      };
}

class SearchMessage {
  final Message message;
  final String title;
  final String receiverId;
  final String receiverCollection;

  SearchMessage(
    this.message,
    this.title,
    this.receiverId,
    this.receiverCollection,
  );
}
