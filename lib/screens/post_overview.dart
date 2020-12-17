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
          body: FutureBuilder(
              future: futurePosts,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.topCenter,
                      child: Text(
                        'GO BE THE FIRST TO CREATE A POST!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailsScreen(
                                  id: snapshot.data.elementAt(index).id,
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
                                          snapshot.data[index].title,
                                          style: TextStyle(fontSize: 20),
                                        ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            "${snapshot.data[index].platform} - ${snapshot.data[index].gamerId}")
                                      ],
                                    )
                                  ],
                                ))),
                      );
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
