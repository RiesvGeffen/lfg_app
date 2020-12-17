import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/models/post_model.dart';

class PostDetailsScreen extends StatefulWidget {
  final String id;
  final String game;
  final String image;

  PostDetailsScreen({Key key, this.id, this.game, this.image})
      : super(key: key);

  @override
  PostDetailsScreenState createState() => PostDetailsScreenState();
}

class PostDetailsScreenState extends State<PostDetailsScreen> {
  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Post post;

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    final response = await postsCollection.doc(widget.id).get();

    if (response.exists) {
      setState(() {
        post = Post.fromJson(response.data(), response.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return CupertinoPageScaffold(
          child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                widget.game,
                style: TextStyle(color: Colors.white),
              ),
            )
          ];
        },
        body: Center(child: CircularProgressIndicator()),
      ));
    } else {
      // VIEW WHEN DATA IS FETCHED
      return CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    widget.game,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ];
            },
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    post.title,
                    style: TextStyle(fontSize: 36),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Platform: ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "\t\t ${post.platform}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Gamer ID: ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "\t ${post.gamerId}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      new Image.network(
                        widget.image,
                        width: 100,
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Row(
                        children: [
                          Text(
                            "Comments:",
                            style: TextStyle(fontSize: 28),
                          )
                        ],
                      ))
                ],
              ),
            )),
      );
    }
  }
}
