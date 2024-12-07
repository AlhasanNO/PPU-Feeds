// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:ppu_feeds/models/comment.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CommentsFeedScreen extends StatefulWidget {
//   final String postId;
//   final String postTitle;

//   const CommentsFeedScreen({
//     super.key,
//     required this.postId,
//     required this.postTitle,
//   });

//   @override
//   State<CommentsFeedScreen> createState() => _CommentsFeedScreenState();
// }

// class _CommentsFeedScreenState extends State<CommentsFeedScreen> {
//   late Future<List<Comment>> futureComments;

//   @override
//   void initState() {
//     super.initState();
//     futureComments = fetchComments(widget.postId);
//   }

//   Future<List<Comment>> fetchComments(String postId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString("token");

//     try {
//       final response = await http.get(
//         Uri.parse("http://feeds.ppu.edu/api/v1/posts/$postId/comments"),
//         headers: {"Authorization": "$token"},
//       );

//       if (response.statusCode == 200) {
//         var jsonList = jsonDecode(response.body) as List;

//         return jsonList
//             .map((json) => Comment.fromJson(json))
//             .toList()
//             .reversed
//             .toList();
//       } else {
//         print("Failed to load comments: ${response.statusCode}");
//         return [];
//       }
//     } catch (e) {
//       print("Error fetching comments: $e");
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.postTitle),
//         backgroundColor: const Color(0xFF0A7075),
//       ),
//       body: FutureBuilder<List<Comment>>(
//         future: futureComments,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(
//               child: Text(
//                 "Error loading comments",
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           } else if (snapshot.hasData) {
//             final comments = snapshot.data!;
//             if (comments.isEmpty) {
//               return const Center(
//                 child: Text(
//                   "No comments yet.",
//                   style: TextStyle(fontSize: 18),
//                 ),
//               );
//             }
//             return ListView.builder(
//               itemCount: comments.length,
//               itemBuilder: (context, index) {
//                 final comment = comments[index];
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 3,
//                   child: ListTile(
//                     title: Text(comment.body),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Date: ${comment.datePosted}"),
//                         Text("User: ${comment.userName}"),
//                         Text("Likes: ${comment.likes}"),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.thumb_up,
//                           color: comment.isLiked ? Colors.blue : Colors.grey),
//                       onPressed: () {
//                         setState(() {
//                           comment.isLiked = !comment.isLiked;
//                           comment.isLiked ? comment.likes++ : comment.likes--;
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text("No comments available."));
//           }
//         },
//       ),
//     );
//   }
// }
