import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/feed/presentation/UI/pages/newsfeed.dart';

class FeedProfile extends StatefulWidget {
  @override
  _FeedProfileState createState() => _FeedProfileState();
}

class _FeedProfileState extends State<FeedProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Posts'),
        backgroundColor: Colors.green[100],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('No user data found.'),
            );
          }
          final userData = snapshot.data!.data() as Map?;
          final List<dynamic> userPosts = userData?['posts'] ?? [];

          return ListView.builder(
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(userPosts[index])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return SizedBox.shrink();
                  }
                  final postData = snapshot.data!.data() as Map?;
                  return PostView(
                    content: postData?['content'] ?? '',
                    imageUrl: postData?['image_url'],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
