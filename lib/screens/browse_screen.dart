import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BrowseScreen extends StatefulWidget {
  BrowseScreen({Key key}) : super(key: key);

  @override
  BrowseScreenState createState() => BrowseScreenState();
}

class BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> widgetList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
    var size = MediaQuery.of(context).size;
    final double itemHeight =
        (size.height - kToolbarHeight - kBottomNavigationBarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                'Browse',
                style: TextStyle(color: Colors.white),
              ),
            )
          ];
        },
        body: CustomScrollView(
          slivers: <Widget>[
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
      ),
    );
  }
}
