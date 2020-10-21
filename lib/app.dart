import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/main.dart';
import 'package:lfg_app/screens/create_post.dart';
import 'package:lfg_app/screens/home_screen.dart';
import 'package:lfg_app/screens/profile_screen.dart';

class LfgApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LfgAppState();
  }
}

class LfgAppState extends State<LfgApp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor:
            CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('Add'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
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
