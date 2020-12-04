import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/models/game_model.dart';
import 'package:lfg_app/screens/browse_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  Future<List<Game>> futureGames;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
  }

  Future<List<Game>> fetchGames() async {
    final response = await gamesCollection.get();

    if (response.size > 0) {
      List<Game> gamesList = List();
      response.docs.forEach((element) {
        Game game = Game.fromJson(element.data(), element.id);
        gamesList.add(game);
      });
      return gamesList;
    } else {
      throw Exception('Empty response');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Home',
                style: TextStyle(color: Colors.white),
              ),
            )
          ];
        },
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(),
            FutureBuilder(
                future: futureGames,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return Text('No Data Found');
                    }
                    return SliverGrid(
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
                                snapshot.data.elementAt(index).title,
                                style: new TextStyle(
                                  fontSize: 50.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: 6,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                }),
            SliverToBoxAdapter(
                child: Container(
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                color: Color.fromARGB(255, 44, 49, 58),
                textColor: Colors.white,
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BrowseScreen(),
                      ))
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("All games", style: TextStyle(fontSize: 20)),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.navigate_next),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
