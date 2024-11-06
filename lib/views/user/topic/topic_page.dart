import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/topic_controller.dart';

class TopicPage extends StatelessWidget {
  final TopicController topicController = Get.put(TopicController());

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
          'กระทู้ของคุณ',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'เพิ่มกระทู้',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Get.toNamed('/addtopic');
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.purple,
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return ListView.builder(
            itemCount: topicController.topics.length,
            itemBuilder: (context, index) {
              final topic = topicController.topics[index];
              return Card(
                color: const Color.fromARGB(255, 235, 235, 235),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text('ชื่อกระทู้: ${topic.title}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.yellow),
                        onPressed: () {
                          // ส่งข้อมูลที่ต้องการแก้ไขไปยังหน้า EditTopicPage
                          Get.toNamed('/edittopic', arguments: {
                            'topicId': topic.id,
                            'title': topic.title,
                            'content': topic.content,
                            'categoryId': topic.categoryId,
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          topicController.deleteTopic(topic.id ?? ''); // Fallback empty string if null
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
