// import 'package:flutter/material.dart';
// import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
// import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
// import 'package:flutter_social_media/src/features/feed/presentation/components/post_card.dart';

// class PostCardById extends StatefulWidget {
//   const PostCardById({super.key, required this.postId});

//   final String postId;

//   @override
//   State<PostCardById> createState() => _PostCardByIdState();
// }

// class _PostCardByIdState extends State<PostCardById> {
//   Post? post;
//   _getPost() async {
//     post = await FeedRepository().fetchPostById(widget.postId);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   bool isLoading = true;

//   @override
//   void initState() {
//     _getPost();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5, top: 26),
//       child:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : post == null
//               ? Text('Post not found')
//               : PostCard(post: post!),
//     );
//   }
// }
