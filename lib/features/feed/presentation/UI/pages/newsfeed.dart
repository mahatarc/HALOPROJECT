import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        backgroundColor: Colors.green[200],
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
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              final post = postDocs[index];

              return PostView(
                content: post['content'],
                imageUrl: post['image_url'],
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

  const PostView({
    required this.content,
    this.imageUrl,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isReported = false;

  @override
  Widget build(BuildContext context) {
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
            // Your post UI components (author row, caption, etc.)
            ListTile(
              title: Text(widget.content),
            ),
            // Call the function to conditionally build the image container
            _buildImageContainer(context),
            SizedBox(height: 8),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  icon: Icon(Icons.comment),
                  onPressed: () {},
                ),
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
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Container(
        width: double.infinity, // Make image fill the width of the card
        height: 200, // Adjust height as needed
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
      print("Invalid imageUrl: ${widget.imageUrl}"); // Debug print statement
      return SizedBox
          .shrink(); // Return an empty SizedBox if imageUrl is null or empty
    }
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

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textEditingController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            _buildPostField(),
            _buildImagePreview(),
            _buildSubmitButton(),
            //  _buildPostList(),
          ],
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
          border: OutlineInputBorder(),
        ),
        maxLines: null, // Allows multiline input
      ),
    );
  }

  Widget _buildImagePreview() {
    return _image == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(_image!),
          );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _submitPost,
          icon: Icon(Icons.send),
          label: Text('Post'),
        ),
        SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _getImage,
          icon: Icon(Icons.image),
          label: Text('Add Photo'),
        ),
      ],
    );
  }

  Future<void> _submitPost() async {
    try {
      final String content = _textEditingController.text;
      final String imageUrl = await _uploadImage();
      await _firestore.collection('posts').add({
        'content': content,
        'image_url': imageUrl,
        'timestamp': Timestamp.now(),
      });
      _textEditingController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      print('Error submitting post: $e');
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) return '';

    final Reference storageRef =
        FirebaseStorage.instance.ref().child('post_images');
    final TaskSnapshot uploadTask = await storageRef.putFile(_image!);
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
