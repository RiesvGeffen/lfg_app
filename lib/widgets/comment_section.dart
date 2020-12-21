import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfg_app/models/comment_model.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  CommentSection({Key key, this.postId}) : super(key: key);

  @override
  CommentSectionState createState() => CommentSectionState();
}

class CommentSectionState extends State<CommentSection> {
  final replyTextController = TextEditingController();

  List<Comment> commentList = List();

  CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection('comments');

  FirebaseAuth auth = FirebaseAuth.instance;
  bool signedIn = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (mounted) {
        if (user == null) {
          setState(() {
            signedIn = false;
          });
        } else {
          setState(() {
            signedIn = true;
          });
        }
      }
    });

    commentsCollection
        .where("postId", isEqualTo: widget.postId)
        .orderBy("created", descending: true)
        .snapshots()
        .listen((QuerySnapshot event) {
      if (event.docChanges.length > 0) {
        event.docChanges.forEach((element) {
          if (element.doc.data()["created"] == null) return;

          Comment comment =
              Comment.fromJson(element.doc.data(), element.doc.id);
          element.doc.data()["userRef"].get().then((DocumentSnapshot doc) {
            setState(() {
              comment.author = doc.data()["username"];
            });
          });
          if (event.docChanges.length == 1) {
            setState(() {
              commentList.insert(0, comment);
            });
          } else {
            setState(() {
              commentList.add(comment);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (signedIn)
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Text(
                        'REPLY',
                        textAlign: TextAlign.start,
                        style: TextStyle(letterSpacing: 1.5),
                      ),
                    ),
                    CupertinoTextField(
                      maxLines: 4,
                      controller: replyTextController,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Color.fromARGB(255, 117, 190, 255),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(0, 0, 0, 0),
                          border: Border.all(
                            color: Color.fromARGB(255, 56, 62, 74),
                            width: 2,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'POST REPLY',
                      style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                    ),
                    onPressed: () {
                      submitForm();
                    },
                  ),
                )
              ],
            ),
          ),
        Text(
          "Comments:",
          style: TextStyle(fontSize: 28),
        ),
        Column(
            children: commentList
                .map((e) => new Container(
                    margin: EdgeInsets.only(top: 20),
                    color: Colors.blueGrey,
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                    child: Text(
                                  e.message,
                                  style: TextStyle(fontSize: 20),
                                ))
                              ],
                            ),
                            Row(
                              children: [Text(" - ${e.author}, ${e.created}")],
                            )
                          ],
                        ))))
                .toList())
      ],
    ));
  }

  submitForm() async {
    String reply = replyTextController.text.trim();

    // Validation
    if (reply == '') {
      // Form is not valid
      return;
    }

    await commentsCollection.add({
      'postId': widget.postId,
      'message': reply,
      'created': FieldValue.serverTimestamp(),
      'userRef': FirebaseFirestore.instance.doc('users/${auth.currentUser.uid}')
    }).then((value) {
      replyTextController.clear();
      FocusScope.of(context).unfocus();
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
