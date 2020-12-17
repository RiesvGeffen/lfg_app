import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfg_app/models/game_model.dart';
import 'package:lfg_app/screens/post_details.dart';

class CreatePostScreen extends StatefulWidget {
  final Function(int) setTabIndex;
  CreatePostScreen({Key key, this.setTabIndex}) : super(key: key);

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  final gamerIdTextController = TextEditingController();
  final titleTextController = TextEditingController();
  int gameSelectedValue = 0;
  int platformSelectedValue = 0;

  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  Future<List<Game>> futureGames;
  List<Game> allGames;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool signedIn = false;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();

    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        setState(() {
          signedIn = false;
        });
      } else {
        setState(() {
          signedIn = true;
        });
      }
    });
  }

  Future<List<Game>> fetchGames() async {
    final response = await gamesCollection.get();

    if (response.size > 0) {
      List<Game> gamesList = List();
      response.docs.forEach((element) {
        Game game = Game.fromJson(element.data(), element.id);
        gamesList.add(game);
      });
      this.allGames = gamesList;
      return gamesList;
    } else {
      throw Exception('Empty response');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      return CupertinoPageScaffold(
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Container(
                  color: Color.fromARGB(255, 33, 37, 43),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    'Create post',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  // GAME
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 4,
                            bottom: 5,
                            top: 20,
                          ),
                          child: Text(
                            'GAME',
                            textAlign: TextAlign.start,
                            style: TextStyle(letterSpacing: 1.5),
                          ),
                        ),
                        FutureBuilder(
                            future: futureGames,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Game>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                if (!snapshot.hasData) {
                                  return Text('No Data Found');
                                }
                                return CupertinoPicker(
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      gameSelectedValue = value;
                                    });
                                  },
                                  itemExtent: 30,
                                  children: snapshot.data
                                      .map((game) => Text(
                                            game.title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic),
                                          ))
                                      .toList(),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            })
                      ],
                    ),
                  ),
                  // PLATFORM
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 4,
                            bottom: 5,
                            top: 20,
                          ),
                          child: Text(
                            'PLATFORM',
                            textAlign: TextAlign.start,
                            style: TextStyle(letterSpacing: 1.5),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: CupertinoPicker(
                            onSelectedItemChanged: (value) {
                              setState(() {
                                platformSelectedValue = value;
                              });
                            },
                            itemExtent: 30,
                            children: const [
                              Text(
                                'Select your platform',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                'Playstation',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Xbox',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'PC',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // GAMER ID
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            'GAMER ID',
                            textAlign: TextAlign.start,
                            style: TextStyle(letterSpacing: 1.5),
                          ),
                        ),
                        CupertinoTextField(
                          controller: gamerIdTextController,
                          cursorColor: Color.fromARGB(255, 117, 190, 255),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(0, 0, 0, 0),
                              border: Border(
                                  bottom: BorderSide(
                                color: Color.fromARGB(255, 56, 62, 74),
                                width: 2,
                              ))),
                        )
                      ],
                    ),
                  ),
                  // TITLE
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            'TITLE',
                            textAlign: TextAlign.start,
                            style: TextStyle(letterSpacing: 1.5),
                          ),
                        ),
                        CupertinoTextField(
                          controller: titleTextController,
                          cursorColor: Color.fromARGB(255, 117, 190, 255),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(0, 0, 0, 0),
                              border: Border(
                                  bottom: BorderSide(
                                color: Color.fromARGB(255, 56, 62, 74),
                                width: 2,
                              ))),
                        )
                      ],
                    ),
                  ),
                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color.fromARGB(255, 56, 62, 74),
                      child: Text(
                        'POST',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 1.5),
                      ),
                      onPressed: () {
                        submitForm();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return CupertinoPageScaffold(
          child: Column(children: [
        SizedBox(
          height: 120,
          child: Container(
              color: Color.fromARGB(255, 33, 37, 43),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Text(
                'Create post',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: Text(
                  'YOU MUST BE SIGNED IN TO CREATE A POST',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                    ),
                    onPressed: () {
                      widget.setTabIndex(2);
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ]));
    }
  }

  submitForm() async {
    // Get values
    int platformId = platformSelectedValue;
    String gamerId = gamerIdTextController.text.trim();
    String title = titleTextController.text.trim();

    // Validation
    if (platformId == 0 || gamerId == '' || title == '') {
      // Form is not valid
      return;
    }

    String gameId = this.allGames.elementAt(gameSelectedValue).id;
    Game game = this.allGames.elementAt(gameSelectedValue);

    String platform;
    switch (platformId) {
      case 1:
        platform = "Playstation";
        break;
      case 2:
        platform = "Xbox";
        break;
      case 3:
        platform = "PC";
        break;
    }

    await postsCollection.add({
      'game': gameId,
      'platform': platform,
      'gamerId': gamerId,
      'title': title
    }).then((value) {
      gamerIdTextController.clear();
      titleTextController.clear();
      FocusScope.of(context).unfocus();

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailsScreen(
              id: value.id,
              game: game.title,
              image: game.image,
            ),
          ));
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
