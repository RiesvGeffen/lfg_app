import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String errorMessage = "";

  final signInEmailTextController = TextEditingController();
  final signInPasswordTextController = TextEditingController();
  final signInRepeatPasswordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          CupertinoSliverNavigationBar(
            previousPageTitle: "Sign In",
            largeTitle: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
          )
        ];
      },
      body: Column(
        children: [
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
                // PASSWORD REPEAT
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          'REPEAT PASSWORD',
                          textAlign: TextAlign.start,
                          style: TextStyle(letterSpacing: 1.5),
                        ),
                      ),
                      CupertinoTextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: signInRepeatPasswordTextController,
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
                      'Sign Up',
                      style: TextStyle(color: Colors.white, letterSpacing: 1.5),
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
    ));
  }

  submitForm() async {
    setState(() {
      errorMessage = "";
    });

    String email = signInEmailTextController.text.trim();
    String password = signInPasswordTextController.text.trim();
    String repeatPassword = signInRepeatPasswordTextController.text.trim();

    if (email == '' || password == '' || repeatPassword == '') {
      setState(() {
        errorMessage = "Please fill in all fields";
      });
      return;
    } else if (password != repeatPassword) {
      setState(() {
        errorMessage = "Make sure passwords match";
      });
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      signInEmailTextController.clear();
      signInPasswordTextController.clear();
      signInRepeatPasswordTextController.clear();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorMessage = "The password provided is too weak";
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          errorMessage = "The account already exists for that email";
        });
      }
    } catch (e) {}
  }
}
