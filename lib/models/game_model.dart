class Game {
  final String id;
  final String title;

  Game({this.id, this.title});

  factory Game.fromJson(Map<String, dynamic> json, String id) {
    return Game(
      id: id,
      title: json['title'],
    );
  }
}
