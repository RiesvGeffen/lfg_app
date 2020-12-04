class Post {
  final String id;
  final String title;
  final String platform;
  final String gamerId;

  Post({this.id, this.title, this.platform, this.gamerId});

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    return Post(
        id: id,
        title: json['title'],
        platform: json['platform'],
        gamerId: json['gamerId']);
  }
}
