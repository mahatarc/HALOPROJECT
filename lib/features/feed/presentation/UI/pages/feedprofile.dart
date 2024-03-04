import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutterproject/features/feed/presentation/UI/pages/newsfeed.dart';
import 'package:flutterproject/features/feed/presentation/UI/pages/comments.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedProfile extends StatefulWidget {
  @override
  _FeedProfileState createState() => _FeedProfileState();
}

class _FeedProfileState extends State<FeedProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
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

          if (userPosts.isEmpty) {
            return Center(
              child: Text('No posts found.'),
            );
          }

          return ListView.builder(
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              final postId = userPosts[index] as String?;
              if (postId == null || postId.isEmpty) {
                print('Skipping post at index $index due to empty ID.');
                return SizedBox.shrink();
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    print('Post document not found for ID: $postId');
                    return SizedBox.shrink();
                  }

                  final postData = snapshot.data!.data() as Map?;
                  final likes =
                      (postData?['likes'] as List<dynamic>?)?.length ?? 0;

                  // Fetch comments separately and pass the count to PostView widget
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('comments')
                        .where('postId', isEqualTo: postId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      }
                      final commentsCount = snapshot.data!.docs.length;

                      return PostView(
                        content: postData?['content'] ?? '',
                        imageUrl: postData?['image_url'] ?? null,
                        postId: postId,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        likes: likes,
                        comments: commentsCount, // Pass comments count
                        onDelete: () {
                          _showDeleteConfirmationDialog(postId);
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deletePost(String postId) async {
    try {
      // Delete the post from 'posts' collection
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

      // Remove the post ID from user's 'posts' array field
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .update({
        'posts': FieldValue.arrayRemove([postId]),
      });
    } catch (error) {
      print('Error deleting post: $error');
    }
  }

  void _showDeleteConfirmationDialog(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deletePost(postId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class PostView extends StatefulWidget {
  final String content;
  final String? imageUrl;
  final String postId;
  final String userId;
  final int likes;
  final int comments;
  final VoidCallback onDelete;

  const PostView({
    required this.content,
    this.imageUrl,
    required this.postId,
    required this.userId,
    required this.likes,
    required this.comments,
    required this.onDelete,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            SizedBox(height: 8),
            Text(
              widget.content,
              style: TextStyle(color: Colors.black87),
            ),
            if (widget.imageUrl != null) ...[
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  if (widget.imageUrl != null) {
                    _launchUrl(widget.imageUrl!);
                  }
                },
                child: Image.network(
                  widget.imageUrl!,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox.shrink(); // Don't show error message
                  },
                ),
              ),
            ],
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {},
                ),
                Text('${widget.likes}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentsScreen(postId: widget.postId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final userData = snapshot.data!.data() as Map?;
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: userData != null &&
                      userData['profilePicture'] != null
                  ? NetworkImage(userData['profilePicture'])
                  : AssetImage('images/profile.jpg') as ImageProvider<Object>?,
            ),
            SizedBox(width: 8),
            Text(
              userData != null ? '${userData["name"]} ' : 'Unknown User',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
