import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/comment_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final AuthController authController = Get.find<AuthController>();
  final int contentLimit = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6332C6),
      appBar: AppBar(
        title: const Text('หน้าแรก'),
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        actions: [
          Obx(() {
            if (authController.isLoggedIn.value) {
              return Row(
                children: [
                  if (authController.userRole.value == 'ADMIN')
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Get.toNamed('/admindashboard');
                      },
                    ),
                  if (authController.userRole.value == 'USER')
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Get.toNamed('/userdashboard');
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      authController.logout();
                    },
                  ),
                ],
              );
            } else {
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
            child: Obx(() {
              return DropdownButton<String>(
                value: controller.selectedCategory.value,
                items: controller.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedCategory.value = value!;
                  controller.fetchPosts(category: value); // กรองโพสต์ตามหมวดหมู่
                },
                hint: const Text("เลือกหมวดหมู่", style: TextStyle(color: Colors.white)),
              );
            }),
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
  bool _isExpanded = false;
  final TextEditingController _commentController = TextEditingController();
  final CommentController commentController = Get.find<CommentController>();
  final AuthController authController = Get.find<AuthController>();

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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = widget.post.comments[index];
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(comment['author'] ?? 'Anonymous'), // ใช้ 'author' จากคอมเมนต์
                      subtitle: Text(comment['content'] ?? ''), // ใช้ 'content' จากคอมเมนต์
                    );
                  },
                ),
                const SizedBox(height: 10),
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
              onPressed: () async {
                if (_commentController.text.isNotEmpty) {
                  // ใช้ userId จาก AuthController
                  await commentController.addComment(
                    _commentController.text,
                    authController.currentUserId.value, // ใช้ currentUserId
                    widget.post.id, // ใช้ postId จากโพสต์
                  );
                  setState(() {
                    widget.post.comments.add({
                      'author': authController.isLoggedIn.value ? 'คุณ' : 'ผู้ใช้', // ใช้ชื่อผู้ใช้จริงถ้ามี
                      'content': _commentController.text,
                    });
                  });
                  _commentController.clear();
                  Navigator.pop(context);
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
            Text('ผู้เขียน: ${post.authorName} โพสต์เมื่อ: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(post.createdAt))}'),
            const SizedBox(height: 5),
            Text(
              _isExpanded
                  ? post.content
                  : (isContentLong ? post.content.substring(0, widget.contentLimit) + '...' : post.content),
            ),
            if (post.imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
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
