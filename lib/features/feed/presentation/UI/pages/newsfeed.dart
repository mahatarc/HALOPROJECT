import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutterproject/features/feed/presentation/UI/pages/comments.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsFeed extends StatefulWidget {
  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green[100],
        title: Text(
          "Feed",
        ),
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
              final content = post['content'] as String;
              final imageUrl = post['image_url'] as String?;
              final postId = post.id;
              final userId = post['user_id'] as String;
              final likes = (post['likes'] as List<dynamic>?)?.length ?? 0;

              return PostView(
                content: content,
                imageUrl: imageUrl,
                postId: postId,
                userId: userId,
                likes: likes,
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
  final String userId;
  final int likes;

  const PostView({
    required this.content,
    this.imageUrl,
    required this.postId,
    required this.userId,
    required this.likes,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isReported = false;
  String? selectedReason;

  void _launchUrl(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

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
            Linkify(
              onOpen: (link) => _launchUrl(link.url),
              text: widget.content,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 8),
            if (widget.imageUrl != null) ...[
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
              SizedBox(height: 8),
            ],
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
                      _toggleLike();
                    });
                  },
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
                IconButton(
                  color: isReported ? Colors.red : null,
                  icon: Icon(Icons.report),
                  onPressed: () {
                    _showReportDialog();
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

  void _toggleLike() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    // Check if the user has already liked the post
    final postSnapshot = await postRef.get();
    final likes = List<String>.from(postSnapshot.data()!['likes'] ?? []);

    if (isLiked) {
      likes.add(userId);
    } else {
      likes.remove(userId);
    }

    // Update the 'likes' field in Firestore
    await postRef.update({'likes': likes});
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report Post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('Inappropriate Content'),
                  onTap: () {
                    setState(() {
                      selectedReason = 'Inappropriate Content';
                    });
                    Navigator.pop(context);
                    _showConfirmationDialog();
                  },
                ),
                ListTile(
                  title: Text('Spam'),
                  onTap: () {
                    setState(() {
                      selectedReason = 'Spam';
                    });
                    Navigator.pop(context);
                    _showConfirmationDialog();
                  },
                ),
                ListTile(
                  title: Text('Other'),
                  onTap: () {
                    setState(() {
                      selectedReason = 'Other';
                    });
                    Navigator.pop(context);
                    _showConfirmationDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to report?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reportPost();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _reportPost() {
    // You can implement reporting logic here, using selectedReason
    print('Post reported for: $selectedReason');
    setState(() {
      isReported = true;
    });
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
            borderRadius: BorderRadius.circular(16.0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
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
              borderRadius: BorderRadius.circular(16.0),
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
              borderRadius: BorderRadius.circular(16.0),
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
        'likes': [], // Initialize likes as an empty array
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
