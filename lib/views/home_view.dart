import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final AuthController authController = Get.find<AuthController>();  // ใช้ AuthController
  final int contentLimit = 200; // Maximum content length to display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6332C6),
      appBar: AppBar(
        title: const Text('หน้าแรก'),
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        actions: [
          // If the user is not logged in, show the "Sign In" button
          Obx(() {
            if (authController.isLoggedIn.value) {
              return Row(
                children: [
                  // Show the user icon if the user is logged in
                  if (authController.userRole.value == 'ADMIN') 
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Get.toNamed('/admindashboard');  // Go to admin dashboard
                      },
                    ),
                    if (authController.userRole.value == 'USER') 
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Get.toNamed('/userdashboard');  // Go to user dashboard
                      },
                    ),
                  // Show the "Logout" button if the user is logged in
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      authController.logout(); // Log out the user
                    },
                  ),
                ],
              );
            } else {
              // Show the "Sign In" button if the user is not logged in
              return TextButton(
                onPressed: () {
                  Get.toNamed('/login');
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.blue),
                ),
              );
            }
          }),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              items: const [
                DropdownMenuItem(value: "หมวดหมู่", child: Text("เลือกหมวดหมู่", style: TextStyle(color: Colors.black))),
                // Add more categories here
              ],
              onChanged: (value) {},
              hint: const Text("เลือกหมวดหมู่", style: TextStyle(color: Colors.white)),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  final post = controller.posts[index];
                  return ExpandablePostCard(post: post, contentLimit: contentLimit);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ExpandablePostCard extends StatefulWidget {
  final dynamic post;
  final int contentLimit;

  const ExpandablePostCard({Key? key, required this.post, required this.contentLimit}) : super(key: key);

  @override
  _ExpandablePostCardState createState() => _ExpandablePostCardState();
}

class _ExpandablePostCardState extends State<ExpandablePostCard> {
  bool _isExpanded = false; // Controls the expanded state of the post content
  final TextEditingController _commentController = TextEditingController(); // Controller for the comment input

  void _showCommentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ความคิดเห็น (${widget.post.comments.length})'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // List of comments
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = widget.post.comments[index];
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(comment['author']),
                      subtitle: Text(comment['content']),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Input field for new comment
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'เขียนความคิดเห็น',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle adding a comment here
                if (_commentController.text.isNotEmpty) {
                  // Assuming your post has a method to add a comment
                  widget.post.comments.add({
                    'author': 'ผู้ใช้', // Replace with the actual user
                    'content': _commentController.text,
                  });

                  // Clear the text field
                  _commentController.clear();
                  setState(() {}); // Update the UI to reflect the new comment
                }
              },
              child: const Text("เพิ่มความคิดเห็น"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ปิด"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isContentLong = post.content.length > widget.contentLimit;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อกระทู้: ${post.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('ผู้เขียน: ${post.author} โพสต์เมื่อ: ${post.date}'),
            const SizedBox(height: 5),
            Text(
              _isExpanded
                  ? post.content
                  : (isContentLong ? post.content.substring(0, widget.contentLimit) + '...' : post.content),
            ),
            if (post.imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center( // Center the image
                  child: Image.network(post.imageUrl),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isContentLong)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(_isExpanded ? 'อ่านน้อยลง' : 'อ่านเพิ่มเติม'),
                  ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    _showCommentsDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
