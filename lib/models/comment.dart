class Comment {
  final int id;
  final String body;
  final String datePosted;
  final String author;

  Comment({
    required this.id,
    required this.body,
    required this.datePosted,
    required this.author,
  });

  factory Comment.fromJson(dynamic jsonObject) {
    return Comment(
      id: int.parse(jsonObject["id"]),
      body: jsonObject["body"],
      datePosted: jsonObject["date_posted"],
      author: jsonObject["author"],
    );
  }
}
