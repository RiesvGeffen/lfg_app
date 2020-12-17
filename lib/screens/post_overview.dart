import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/models/post_model.dart';
import 'package:lfg_app/screens/post_details.dart';

class PostOverviewScreen extends StatefulWidget {
  final String id;
  final String title;
  final String image;

  PostOverviewScreen({Key key, this.id, this.title, this.image})
      : super(key: key);

  @override
  PostOverviewScreenState createState() => PostOverviewScreenState();
}

class PostOverviewScreenState extends State<PostOverviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Query posts = FirebaseFirestore.instance
        .collection('posts')
        .where("game", isEqualTo: widget.id)
        .orderBy("created", descending: true);

    return CupertinoPageScaffold(
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                previousPageTitle: "Back",
                trailing: new Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                ),
                largeTitle: Text(
                  widget.title,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ];
          },
          body: StreamBuilder(
              stream: posts.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data.docs.length < 1) {
                  return Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: Text(
                      'GO BE THE FIRST TO CREATE A POST!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }

                Iterable<Post> postList = snapshot.data.docs
                    .map((e) => Post.fromJson(e.data(), e.id));

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: postList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailsScreen(
                                id: postList.elementAt(index).id,
                                game: widget.title,
                                image: widget.image,
                              ),
                            ))
                      },
                      child: Container(
                          color: Colors.blue,
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        postList.elementAt(index).title,
                                        style: TextStyle(fontSize: 20),
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "${postList.elementAt(index).platform} - ${postList.elementAt(index).gamerId}")
                                    ],
                                  )
                                ],
                              ))),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              })),
    );
  }
}
