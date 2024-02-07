import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/homepage/home_icons/forum.dart';

class NewsFeed extends StatefulWidget {
  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[200],
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 2.0,
          tabs: [
            Tab(
              icon: Icon(Icons.feed),
              text: "Feed",
            ),
            Tab(
              icon: Icon(Icons.chat_bubble),
              text: "Forum",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PostsListView(),
          ForumHomeScreen(),
        ],
      ),
    );
  }

  Widget PostAuthorRow() {
    const double avatarDiameter = 72;
    return GestureDetector(
      onTap: () {
        // Add functionality for tapping on the author row
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: avatarDiameter,
              height: avatarDiameter,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(avatarDiameter / 2),
                child: Image.asset(
                  'images/profile.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            'Alphawave',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.teal[400],
            ),
          )
        ],
      ),
    );
  }

  Widget PostImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        'images/agro.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget PostCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Text(
        'Hello World!',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget PostView() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailScreen()),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostAuthorRow(),
            PostCaption(),
            PostImage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    // Add functionality for liking the post
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentsScreen()),
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

  Widget PostsListView() {
    return ListView.separated(
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        return PostView();
      },
    );
  }
}

class User {
  final String name;
  final String profilePicture;

  User({required this.name, required this.profilePicture});
}

class CommentItem extends StatelessWidget {
  final String comment;
  final User user;

  CommentItem({required this.comment, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage(user.profilePicture),
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[400],
                ),
              ),
              SizedBox(height: 8.0),
              Text(comment),
            ],
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
            child: Text('Post'),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal[400],
              onPrimary: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final List<CommentItem> comments = [
    CommentItem(
      comment: 'This is a comment.',
      user: User(name: 'John Doe', profilePicture: 'images/profile.jpg'),
    ),
    CommentItem(
      comment: 'Great post!',
      user: User(name: 'Jane Doe', profilePicture: 'images/profile.jpg'),
    ),
    CommentItem(
      comment: 'Interesting!',
      user: User(name: 'Alice Smith', profilePicture: 'images/profile.jpg'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return comments[index];
              },
            ),
          ),
          CommentInput(),
        ],
      ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Center(
        child: Text('Full post description goes here'),
      ),
    );
  }
}
