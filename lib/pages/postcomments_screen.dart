import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppu_feeds/models/comment.dart';

class PostCommentsScreen extends StatefulWidget {
  final int courseId;
  final int sectionId;
  final int postId;

  const PostCommentsScreen({
    super.key,
    required this.courseId,
    required this.sectionId,
    required this.postId,
  });

  @override
  State<PostCommentsScreen> createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  late Future<List<Comment>> futureComments;

  @override
  void initState() {
    super.initState();
    futureComments =
        fetchComments(widget.courseId, widget.sectionId, widget.postId);
  }

  Future<List<Comment>> fetchComments(
      int courseId, int sectionId, int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse(
            "http://feeds.ppu.edu/api/v1/courses/$courseId/sections/$sectionId/posts/$postId/comments"),
        headers: {"Authorization": "$token"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> commentsJson = jsonResponse["comments"];
        return commentsJson.map((e) => Comment.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load comments: ${response.statusCode}");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: FutureBuilder<List<Comment>>(
        future: futureComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No comments found"));
          }

          final comments = snapshot.data!;

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Column(
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.author,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 1.0,
                            ),
                            Text(
                              comment.datePosted,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Text(
                              comment.body,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
