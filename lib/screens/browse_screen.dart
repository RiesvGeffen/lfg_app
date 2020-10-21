import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BrowseScreen extends StatefulWidget {
  BrowseScreen({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  BrowseScreenState createState() => BrowseScreenState();
}

class BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> widgetList = ['A', 'B', 'C', 'D', 'E', 'C', 'D', 'E', 'F'];
    var size = MediaQuery.of(context).size;
    final double itemHeight =
        (size.height - kToolbarHeight - kBottomNavigationBarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Browse'),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return new Container(
                  color: Colors.green,
                  margin: new EdgeInsets.all(1.0),
                  child: new Center(
                    child: new Text(
                      widgetList[index],
                      style: new TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              childCount: widgetList.length,
            ),
          )
        ],
      ),
    );
  }
}
