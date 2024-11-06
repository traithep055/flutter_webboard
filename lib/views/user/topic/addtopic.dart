import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/topic_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/topic_model.dart';

class AddTopicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    String? selectedCategory;

    final topicController = Get.find<TopicController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'สร้างกระทู้',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.purple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            color: const Color.fromARGB(255, 202, 155, 225),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('หมวดหมู่:'),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: topicController.categories.isEmpty
                          ? [DropdownMenuItem(value: null, child: Text('กำลังโหลด...'))]
                          : [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text('เลือก'),
                              )
                            ] +
                              topicController.categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category['id'],  // ใช้ 'id' เป็นค่า
                                  child: Text(category['name']!),  // แสดงชื่อของหมวดหมู่
                                );
                              }).toList(),
                      onChanged: (value) {
                        selectedCategory = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 235, 235, 235),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),

                  const Text('ชื่อกระทู้:'),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 235, 235, 235),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text('เนื้อหา:'),
                  TextField(
                    controller: contentController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 235, 235, 235),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text('ไฟล์:'),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'เลือกไฟล์',
                            filled: true,
                            fillColor: Color.fromARGB(255, 235, 235, 235),
                          ),
                          onTap: () {
                            // ส่วนนี้ใช้เลือกไฟล์ ถ้าจำเป็น
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (selectedCategory != null && selectedCategory != 'เลือก') {
                          String authorId = authController.currentUserId.value;

                          final newTopic = TopicModel(
                            title: titleController.text,
                            content: contentController.text,
                            authorId: authorId,
                            categoryId: selectedCategory!,
                          );

                          topicController.addTopic(
                            newTopic.title,
                            newTopic.content,
                            newTopic.authorId,
                            newTopic.categoryId,
                          );

                          Navigator.pop(context);
                        } else {
                          Get.snackbar('Error', 'Please select a category');
                        }
                      },
                      child: const Text(
                        'โพสต์',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
