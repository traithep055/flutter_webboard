import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/ban_controller.dart';

class BanUserPage extends StatelessWidget {
  final BanController userController = Get.put(BanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6332C6),
      appBar: AppBar(
        title: const Text('แบนผู้ใช้'),
        backgroundColor: Colors.grey[300],
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            var user = userController.users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Text(
                  user['name'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(
                    (user['isBanned'] as bool) ? Icons.block : Icons.person,
                    color: (user['isBanned'] as bool) ? Colors.red : Colors.green,
                  ),
                  onPressed: () {
                    userController.toggleBan(user['id'] as String, user['email'] as String);
                  },
                ),
                subtitle: Text(
                  (user['isBanned'] as bool) ? 'ถูกแบนแล้ว' : 'ใช้งานได้',
                  style: TextStyle(
                    color: (user['isBanned'] as bool) ? Colors.red : Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
