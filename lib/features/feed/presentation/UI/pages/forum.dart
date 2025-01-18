import 'package:flutter/material.dart';

class ForumHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.green[200],
        elevation: 2.0,
        title: Text('Forum Topics'),
      ),*/
      body: ForumTopicsList(),
    );
  }
}

class ForumTopicsList extends StatelessWidget {
  final List<String> topics = [
    'Reviews and Ratings',
    'Suggestions and Ideas',
    'General Discussions',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: topics.map((topic) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(
                topic,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.topic),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForumThreadList(topic: topic),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ForumThreadList extends StatelessWidget {
  final String topic;

  ForumThreadList({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        elevation: 2.0,
        title: Text(topic),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: ForumPostsList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumPostsList extends StatelessWidget {
  final List<String> posts = [
    'Post 1',
    'Post 2',
    'Post 3',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ListTile(
            title: Text(
              posts[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.article),
            subtitle: Text('Posted on: ${DateTime.now().toString()}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailsScreen(post: posts[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class PostDetailsScreen extends StatelessWidget {
  final String post;

  PostDetailsScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        elevation: 2.0,
        title: Text('Post Details'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                post,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            Expanded(
              child: CommentList(),
            ),
            CommentInput(),
          ],
        ),
      ),
    );
  }
}

class Comment {
  final String content;
  final User user;

  Comment({required this.content, required this.user});
}

class CommentList extends StatelessWidget {
  final List<Comment> comments = [
    Comment(
        content: 'Comment 1',
        user: User(name: 'Alphawave', profilePicture: 'images/profile.jpg')),
    Comment(
        content: 'Comment 2',
        user: User(name: 'Ram', profilePicture: 'images/profile.jpg')),
    Comment(
        content: 'Comment 3',
        user: User(name: 'Shyam', profilePicture: 'images/profile.jpg')),
    // Add more comments as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return CommentItem(comment: comments[index]);
        },
      ),
    );
  }
}

class CommentItem extends StatefulWidget {
  final Comment comment;

  CommentItem({required this.comment});

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isReported = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24.0,
            backgroundColor: Colors.green[400], // Avatar border color
            child: CircleAvatar(
              radius: 22.0,
              backgroundImage: AssetImage(widget.comment.user.profilePicture),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comment.user.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.content,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            color: isLiked ? Colors.blue : null,
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                                if (isDisliked) {
                                  isDisliked = false;
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.thumb_down),
                            color: isDisliked ? Colors.red : null,
                            onPressed: () {
                              setState(() {
                                isDisliked = !isDisliked;
                                if (isLiked) {
                                  isLiked = false;
                                }
                              });
                            },
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Likes: 10', // Replace with actual like count
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            icon: Icon(Icons.report),
                            color: isReported ? Colors.yellow : null,
                            onPressed: () {
                              setState(() {
                                isReported = !isReported;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
              // Add functionality to send the comment
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green[400],
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final String profilePicture;

  User({required this.name, required this.profilePicture});
}
