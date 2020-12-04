import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/main.dart';
import 'package:lfg_app/screens/create_post.dart';
import 'package:lfg_app/screens/home_screen.dart';
import 'package:lfg_app/screens/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';

class LfgApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LfgAppState();
  }
}

class LfgAppState extends State<LfgApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Center(
        child: Text(_error.toString()),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Main view
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Color.fromARGB(255, 117, 190, 255),
        inactiveColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 33, 37, 43),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Container(),
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              homeTabNavKey.currentState.popUntil((r) => r.isFirst);
              break;
            case 1:
              createPostTabNavKey.currentState.popUntil((r) => r.isFirst);
              break;
            case 2:
              profileTabNavKey.currentState.popUntil((r) => r.isFirst);
              break;
          }
        },
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return CupertinoTabView(
            navigatorKey: homeTabNavKey,
            builder: (BuildContext context) => HomeScreen(),
          );
        } else if (index == 1) {
          return CupertinoTabView(
            navigatorKey: createPostTabNavKey,
            builder: (BuildContext context) => CreatePostScreen(),
          );
        } else {
          return CupertinoTabView(
            navigatorKey: profileTabNavKey,
            builder: (BuildContext context) => ProfileScreen(),
          );
        }
      },
    );
  }
}
