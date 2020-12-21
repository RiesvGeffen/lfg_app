class Game {
  final String id;
  final String title;
  final String image;

  Game({this.id, this.title, this.image});

  factory Game.fromJson(Map<String, dynamic> json, String id) {
    return Game(
      id: id,
      title: json['title'],
      image: json['image'],
    );
  }

  @override
  String toString() {
    return this.title;
  }
}
