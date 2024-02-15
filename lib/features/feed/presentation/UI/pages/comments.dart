import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  CommentsScreen({required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.green[100],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildCommentsList(),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: widget.postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final commentDocs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: commentDocs.length,
          itemBuilder: (context, index) {
            final comment = commentDocs[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(comment['userId'])
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                }
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;

                if (userData == null) {
                  return SizedBox.shrink();
                }
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('comments')
                      .doc(comment.id)
                      .get(),
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox.shrink();
                    }
                    final likesCount = commentSnapshot.data != null &&
                            commentSnapshot.data!['likes'] != null
                        ? (commentSnapshot.data!['likes'] as List<dynamic>)
                            .length
                        : 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userData['profilePicture'] ?? ''),
                          ),
                          title: Text(userData['name'] ?? 'Unknown User'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment['content'] ?? ''),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.thumb_up),
                                    onPressed: () {
                                      _toggleLike(comment.id);
                                    },
                                  ),
                                  Text(
                                    '$likesCount',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.reply),
                                    onPressed: () {
                                      _showReplyDialog(comment.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildRepliesList(comment.id),
                        Divider(),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRepliesList(String commentId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('replies')
          .where('commentId', isEqualTo: commentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        final replyDocs = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: replyDocs.map((reply) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(reply['userId'])
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                }
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;

                if (userData == null) {
                  return SizedBox.shrink();
                }
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(userData['profilePicture'] ?? ''),
                  ),
                  title: Text(userData['name'] ?? 'Unknown User'),
                  subtitle: Text(reply['content'] ?? ''),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              _submitComment();
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green[400],
              onPrimary: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(String commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reply"),
          content: TextField(
            controller: _replyController,
            decoration: InputDecoration(
              hintText: 'Write a reply...',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitReply(commentId);
              },
              child: Text("Reply"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitReply(String commentId) async {
    final String content = _replyController.text;
    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a reply.'),
        ),
      );
      return;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      // Add the reply to the 'replies' collection
      await FirebaseFirestore.instance.collection('replies').add({
        'commentId': commentId,
        'userId': currentUser!.uid,
        'content': content,
        'timestamp': Timestamp.now(),
      });

      _replyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reply Added Successfully!'),
        ),
      );
    } catch (e) {
      print('Error submitting reply: $e');
    }
  }

  Future<void> _submitComment() async {
    final String content = _commentController.text;
    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a comment.'),
        ),
      );
      return;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      // Add the comment to the 'comments' collection
      await FirebaseFirestore.instance.collection('comments').add({
        'postId': widget.postId,
        'userId': currentUser!.uid,
        'content': content,
        'timestamp': Timestamp.now(),
        'likes': [], // Initialize likes as an empty array
      });

      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment Added Successfully!'),
        ),
      );
    } catch (e) {
      print('Error submitting comment: $e');
    }
  }

  void _toggleLike(String commentId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final commentRef =
        FirebaseFirestore.instance.collection('comments').doc(commentId);

    // Check if the user has already liked the comment
    final commentSnapshot = await commentRef.get();
    final likes = List<String>.from(commentSnapshot.data()!['likes'] ?? []);

    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    // Update the 'likes' field in Firestore
    await commentRef.update({'likes': likes});
  }
}
