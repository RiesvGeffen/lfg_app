import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lfg_app/models/game_model.dart';
import 'package:lfg_app/screens/post_overview.dart';

class BrowseScreen extends StatefulWidget {
  BrowseScreen({Key key}) : super(key: key);

  @override
  BrowseScreenState createState() => BrowseScreenState();
}

class BrowseScreenState extends State<BrowseScreen> {
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
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              previousPageTitle: "Home",
              largeTitle: Text(
                'Browse',
                style: TextStyle(color: Colors.white),
              ),
            )
          ];
        },
        body: FutureBuilder(
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
                return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.0,
                        childAspectRatio: 0.75,
                      ),
                      children: snapshot.data
                          .map((game) => Container(
                                margin: new EdgeInsets.all(1.0),
                                child: GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostOverviewScreen(
                                                  id: game.id,
                                                  title: game.title,
                                                  image: game.image),
                                        ))
                                  },
                                  child: new Image.network(
                                    game.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))
                          .toList(),
                    ));
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
