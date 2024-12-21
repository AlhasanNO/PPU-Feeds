class Post {
  final int id;
  final String body;
  final String datePosted;
  final String author;

  Post({
    required this.id,
    required this.body,
    required this.datePosted,
    required this.author,
  });

  factory Post.fromJson(dynamic jsonObject) {
    return Post(
      id: jsonObject["id"],
      body: jsonObject["body"],
      datePosted: jsonObject["date_posted"],
      author: jsonObject["author"],
    );
  }
}
