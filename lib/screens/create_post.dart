import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key key}) : super(key: key);

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int selectedValue;

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
          Form(
            key: _formKey,
            child: Container(
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
                              selectedValue = value;
                            });
                          },
                          itemExtent: 30,
                          children: const [
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
                                selectedValue = value;
                              });
                            },
                            itemExtent: 30,
                            children: const [
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
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
