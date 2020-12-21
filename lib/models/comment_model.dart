import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comment {
  final String id;
  final String message;
  final String created;
  String author = "";

  Comment({this.id, this.message, this.created});

  factory Comment.fromJson(Map<String, dynamic> json, String id) {
    Timestamp _created = json["created"];
    return Comment(
      id: id,
      message: json['message'],
      created: timeago.format(_created?.toDate()),
    );
  }
}
