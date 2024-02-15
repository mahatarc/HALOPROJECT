import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/feed/presentation/UI/pages/comments.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class NewsFeed extends StatefulWidget {
  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green[100],
          title: Text("Feed"),
          ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final postDocs = snapshot.data!.docs;
          return ListView.separated(
            itemCount: postDocs.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, index) {
              final post = postDocs[index];
              return PostView(
                content: post['content'],
                imageUrl: post['image_url'],
                postId: post.id,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPost()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green[100],
      ),
    );
  }
}

class PostView extends StatefulWidget {
  final String content;
  final String? imageUrl;
  final String postId;

  const PostView({
    required this.content,
    this.imageUrl,
    required this.postId,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  Future<void> _refresh() async {
    // Simulate refreshing data
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Add logic to fetch updated data from Firebase or other data source
    });
  }

  bool isLiked = false;
  bool isDisliked = false;
  bool isReported = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
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
            SizedBox(height: 8),
            _buildImageContainer(context),
            SizedBox(height: 8),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  color: isLiked ? Colors.blue : null,
                  icon: Icon(Icons.thumb_up),
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
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(postId: widget.postId),
                        ),
                      );
                    }),
                IconButton(
                  color: isReported ? Colors.red : null,
                  icon: Icon(Icons.report),
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
    );
  }

  Widget _buildUserInfo() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(), // Fetch user data based on userId
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
                backgroundImage:
                    userData != null && userData['profilePicture'] != null
                        ? NetworkImage(userData['profilePicture'])
                        : AssetImage('images/profile.jpg')
                            as ImageProvider<Object>?,
              ),
              SizedBox(width: 8),
              Text(
                userData != null ? '${userData["name"]} ' : 'Unknown User',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Image.network(
          widget.imageUrl!,
          fit: BoxFit.cover,
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
            return Text('Error loading image');
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _textEditingController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        backgroundColor: Colors.green[100],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPostField(),
              _buildImagePreview(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: 'What\'s on your mind?',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onTap: () {
          final text = _textEditingController.text;
          final urls = RegExp(r'https?://[^\s]+').allMatches(text);
          for (final match in urls) {
            _launchUrl(match.group(0)!);
          }
        },
      ),
    );
  }

  Widget _buildImagePreview() {
    return _image == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.file(_image!),
            ),
          );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _submitPost,
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          label: Text(
            'Post',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 153, 231, 156),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _getImage,
          icon: Icon(
            Icons.image,
            color: Colors.white,
          ),
          label: Text('Add Photo', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 153, 231, 156),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitPost() async {
    try {
      final String content = _textEditingController.text;
      final String imageUrl = _image != null ? await _uploadImage() : '';

      if (content.isEmpty && imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The post cannot be empty.'),
          ),
        );
        return;
      }

      // Add the post to the 'posts' collection
      final newPostRef =
          await FirebaseFirestore.instance.collection('posts').add({
        'content': content,
        'image_url': imageUrl,
        'user_id':
            FirebaseAuth.instance.currentUser!.uid, // Add user ID to post data
      });

      // Get the current user's ID
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;

      // Update the user's document with the new post ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .update({
        'posts': FieldValue.arrayUnion([newPostRef.id]),
      });

      _textEditingController.clear();
      setState(() {
        _image = null;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post Added Successfully!'),
        ),
      );
    } catch (e) {
      print('Error submitting post: $e');
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) return '';

    final Reference storageRef =
        FirebaseStorage.instance.ref().child('post_images');

    // Generate a unique ID for the image file
    final String uniqueID = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload the image file with the unique ID appended to the filename
    final TaskSnapshot uploadTask =
        await storageRef.child('image_$uniqueID').putFile(_image!);

    // Get the download URL of the uploaded image
    final String imageUrl = await uploadTask.ref.getDownloadURL();

    return imageUrl;
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
