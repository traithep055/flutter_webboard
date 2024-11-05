import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/category_controller.dart';

class CategoryPage extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6332C6),
      appBar: AppBar(
        title: const Text('จัดการหมวดหมู่'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: const Color(0xFF6332C6),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add new category logic here
                      controller.addCategory("หมวดหมู่ใหม่");
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'เพิ่มหมวดหมู่',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Use backgroundColor instead of primary
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('ชื่อหมวดหมู่: ${category.name}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.yellow),
                              onPressed: () {
                                // Edit category logic here
                                controller.editCategory(index, "หมวดหมู่แก้ไข");
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Delete category logic here
                                controller.deleteCategory(index);
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
          ],
        ),
      ),
    );
  }
}
