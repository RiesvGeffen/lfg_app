import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfg_app/screens/register_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool signedIn = false;
  String errorMessage = "";

  final signInEmailTextController = TextEditingController();
  final signInPasswordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      return CupertinoPageScaffold(
          child: Column(children: [
        SizedBox(
          height: 120,
          child: Container(
              color: Color.fromARGB(255, 33, 37, 43),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Text(
                auth.currentUser.email,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                  ),
                  onPressed: () {
                    signOut();
                  },
                ),
              )
            ],
          ),
        )
      ]));
    } else {
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
                    'Sign In',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  // EMAIL
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 4, top: 20),
                          child: Text(
                            'EMAIL',
                            textAlign: TextAlign.start,
                            style: TextStyle(letterSpacing: 1.5),
                          ),
                        ),
                        CupertinoTextField(
                          controller: signInEmailTextController,
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
                  // PASSWORD
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            'PASSWORD',
                            textAlign: TextAlign.start,
                            style: TextStyle(letterSpacing: 1.5),
                          ),
                        ),
                        CupertinoTextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: signInPasswordTextController,
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
                        'Sign In',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 1.5),
                      ),
                      onPressed: () {
                        submitForm();
                      },
                    ),
                  ),
                  Divider(
                    color: Color.fromARGB(255, 56, 62, 74),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color.fromARGB(255, 56, 62, 74),
                      child: Text(
                        'Sign Up',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 1.5),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
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
    }
  }

  signOut() async {
    await auth.signOut();
  }

  submitForm() async {
    String email = signInEmailTextController.text.trim();
    String password = signInPasswordTextController.text.trim();

    if (email == '' || password == '') {
      setState(() {
        errorMessage = "Please fill in all fields";
      });
      return;
    }

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      signInEmailTextController.clear();
      signInPasswordTextController.clear();
    } on FirebaseAuthException {
      setState(() {
        errorMessage = "Wrong credentails";
      });
    }
  }
}
