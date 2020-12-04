import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/models/post_model.dart';

class PostOverviewScreen extends StatefulWidget {
  final String id;
  final String title;

  PostOverviewScreen({Key key, this.id, this.title}) : super(key: key);

  @override
  PostOverviewScreenState createState() => PostOverviewScreenState();
}

class PostOverviewScreenState extends State<PostOverviewScreen> {
  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    final response =
        await postsCollection.where("game", isEqualTo: widget.id).get();

    List<Post> postsList = List();
    if (response.size > 0) {
      response.docs.forEach((element) {
        Post post = Post.fromJson(element.data(), element.id);
        postsList.add(post);
      });
      return postsList;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  widget.title,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ];
          },
          body: FutureBuilder(
              future: futurePosts,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Text('No Data Found');
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          color: Colors.blue,
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data[index].title,
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "${snapshot.data[index].platform} - ${snapshot.data[index].gamerId}")
                                    ],
                                  )
                                ],
                              )));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
