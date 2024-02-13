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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
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
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(userData['profilePicture'] ?? ''),
                  ),
                  title: Text(userData['name'] ?? 'Unknown User'),
                  subtitle: Text(comment['content'] ?? ''),
                );
              },
            );
          },
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
}
