import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

class CourseFeedScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  CourseFeedScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<CourseFeedScreen> createState() => _CourseFeedScreenState();
}

class _CourseFeedScreenState extends State<CourseFeedScreen> {
  List<Post> posts = [];
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      var response = await http.get(
        Uri.parse(
            "http://feeds.ppu.edu/api/v1/courses/${widget.courseId}/posts"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        print(response.body);
        var jsonResponse = jsonDecode(response.body);
        var jsonList = jsonResponse as List;
        return jsonList.map((e) => Post.fromJson(e)).toList();
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A7075),
        title: Text(
          widget.courseName,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Post>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                posts = snapshot.data!;
              }

              if (posts.isEmpty) {
                return const Center(
                  child: Text(
                    "No posts available for this course",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            post.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Date: ${post.datePosted}'),
                              Text('Lecturer: ${post.author}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/post");
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
