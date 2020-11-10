import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostOverviewScreen extends StatefulWidget {
  PostOverviewScreen({Key key}) : super(key: key);

  @override
  PostOverviewScreenState createState() => PostOverviewScreenState();
}

class PostOverviewScreenState extends State<PostOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Text("Hellow world!"),
    );
  }
}
