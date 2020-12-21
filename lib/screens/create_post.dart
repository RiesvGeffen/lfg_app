import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfg_app/models/game_model.dart';
import 'package:lfg_app/screens/post_details.dart';
import 'package:lfg_app/widgets/picker_widget.dart';

class CreatePostScreen extends StatefulWidget {
  final Function(int) setTabIndex;
  CreatePostScreen({Key key, this.setTabIndex}) : super(key: key);

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  String errorMessage = "";
  final gamerIdTextController = TextEditingController();
  final titleTextController = TextEditingController();
  int gameSelectedValue = -1;
  int platformSelectedValue = -1;

  List<String> allPlatforms =
      new List.unmodifiable(["Playstation", "Xbox", "PC"]);

  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  List<Game> allGames;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool signedIn = false;

  @override
  void initState() {
    super.initState();
    fetchGames();

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

  void fetchGames() async {
    final response = await gamesCollection.get();

    if (response.size > 0) {
      List<Game> gamesList = List();
      response.docs.forEach((element) {
        Game game = Game.fromJson(element.data(), element.id);
        gamesList.add(game);
      });
      this.allGames = gamesList;
    } else {
      throw Exception('No games found');
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
                    width: double.infinity,
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
                        Container(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => {
                              _showCustomTimePicker("Pick your game", allGames,
                                  setGameSelectedValue, gameSelectedValue)
                            },
                            child: Text(
                              gameSelectedValue == -1
                                  ? "Select your game"
                                  : allGames
                                      .elementAt(gameSelectedValue)
                                      .toString(),
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // PLATFORM
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 20),
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
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => {
                              _showCustomTimePicker(
                                  "Pick your platform",
                                  allPlatforms,
                                  setPlatformSelectedValue,
                                  platformSelectedValue)
                            },
                            child: Text(
                              platformSelectedValue == -1
                                  ? "Select your platform"
                                  : allPlatforms
                                      .elementAt(platformSelectedValue)
                                      .toString(),
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
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
                          textCapitalization: TextCapitalization.sentences,
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
                          textCapitalization: TextCapitalization.sentences,
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
                      color: Colors.blue,
                      child: Text(
                        'POST',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 1.5),
                      ),
                      onPressed: () {
                        submitForm();
                      },
                    ),
                  ),
                  Text(errorMessage, style: TextStyle(color: Colors.red))
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

  void setPlatformSelectedValue(int newValue) {
    this.platformSelectedValue = newValue;
  }

  void setGameSelectedValue(int newValue) {
    this.gameSelectedValue = newValue;
  }

  void _showCustomTimePicker(
      String title, List values, Function(int) setNewValue, int initialValue) {
    showModalBottomSheet(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => ModalPickerWidget(
            title: title,
            values: values,
            onChange: (newValue) => setNewValue(newValue),
            initialValue: initialValue)).whenComplete(() {
      setState(() {});
    });
  }

  void submitForm() async {
    if (errorMessage != "") {
      setState(() {
        errorMessage = "";
      });
    }

    // Get values
    String gamerId = gamerIdTextController.text.trim();
    String title = titleTextController.text.trim();

    // Validation
    if (platformSelectedValue == -1 ||
        gameSelectedValue == -1 ||
        gamerId == '' ||
        title == '') {
      setState(() {
        errorMessage = "Please fill in all fields";
      });
      return;
    }

    Game game = allGames.elementAt(gameSelectedValue);
    String platform = allPlatforms.elementAt(platformSelectedValue);

    await postsCollection.add({
      'game': game.id,
      'platform': platform,
      'gamerId': gamerId,
      'title': title,
      'created': FieldValue.serverTimestamp(),
      'userRef': FirebaseFirestore.instance.doc('users/${auth.currentUser.uid}')
    }).then((value) {
      setState(() {
        platformSelectedValue = -1;
        gameSelectedValue = -1;
      });
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
    }).catchError((error) => print("Failed to add post: $error"));
  }
}
