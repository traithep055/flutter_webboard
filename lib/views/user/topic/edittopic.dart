import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../controllers/topic_controller.dart';
import '../../../controllers/auth_controller.dart';


class EditTopicPage extends StatefulWidget {
  const EditTopicPage({Key? key}) : super(key: key);

  @override
  _EditTopicPageState createState() => _EditTopicPageState();
}

class _EditTopicPageState extends State<EditTopicPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? selectedCategory;
  late TopicController topicController;
  late AuthController authController;
  late String topicId;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    topicController = Get.find<TopicController>();
    authController = Get.find<AuthController>();

    final arguments = Get.arguments as Map<String, dynamic>;
    topicId = arguments['topicId'];
    titleController.text = arguments['title'];
    contentController.text = arguments['content'];
    selectedCategory = arguments['categoryId'];
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'แก้ไขกระทู้',
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
                              DropdownMenuItem<String>(value: null, child: Text('เลือก'))
                            ] +
                              topicController.categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category['id'],
                                  child: Text(category['name']!),
                                );
                              }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
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
                          controller: TextEditingController(
                            text: selectedFile?.path.split('/').last ?? 'เลือกไฟล์',
                          ),
                          readOnly: true,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 235, 235, 235),
                          ),
                          onTap: _pickFile,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: _pickFile,
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

                          topicController.editTopic(
                            topicId,
                            titleController.text,
                            contentController.text,
                            selectedCategory!,
                            selectedFile,
                          );

                          Navigator.pop(context);
                        } else {
                          Get.snackbar('Error', 'Please select a category');
                        }
                      },
                      child: const Text(
                        'บันทึกการแก้ไข',
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