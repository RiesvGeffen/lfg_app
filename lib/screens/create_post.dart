import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key key}) : super(key: key);

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  final gamerIdTextController = TextEditingController();
  final titleTextController = TextEditingController();
  int gameSelectedValue = 0;
  int platformSelectedValue = 0;

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
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
                      CupertinoPicker(
                        onSelectedItemChanged: (value) {
                          setState(() {
                            gameSelectedValue = value;
                          });
                        },
                        itemExtent: 30,
                        children: const [
                          Text(
                            'Select your game',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            'Rocket League',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Call of Duty: Modern Warfare',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Minecraft',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
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
        ],
      ),
    );
  }

  submitForm() async {
    // Get values
    int game = gameSelectedValue;
    int platform = platformSelectedValue;
    String gamerId = gamerIdTextController.text.trim();
    String title = titleTextController.text.trim();

    // Validation
    if (game == 0 || platform == 0 || gamerId == '' || title == '') {
      // Form is not valid
      return;
    }

    debugPrint(game.toString());
    debugPrint(platform.toString());
    debugPrint(gamerId);
    debugPrint(title);

    await posts
        .add({
          'game': game.toString(),
          'platform': platform.toString(),
          'gamerId': gamerId,
          'title': title
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add user: $error"));

    // TODO: Add success handling
  }
}
