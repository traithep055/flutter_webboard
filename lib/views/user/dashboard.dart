import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';

class UserDashboard extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Get.offNamed('/home', arguments: {
              // สามารถส่ง arguments ได้หากต้องการ
            });
            // เรียกใช้ controller ที่จำเป็นเมื่อกลับไปหน้า home
            final homeController = Get.find<HomeController>();
            homeController.fetchPosts();
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black), // เปลี่ยนสีตัวอักษรเป็นดำตามรูป
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.png'), // แทนที่ด้วย path ของรูปภาพ avatar
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.purple,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // ปุ่มยืดเต็มความกว้างตามที่รูปแสดง
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              icon: const Icon(Icons.book),
              label: const Text(
                'เขียนกระทู้',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                // นำทางไปยังหน้าเขียนกระทู้
                Get.toNamed('/topic');
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              icon: const Icon(Icons.person),
              label: const Text(
                'ข้อมูลส่วนตัว',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                // นำทางไปยังหน้าข้อมูลส่วนตัว
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              icon: const Icon(Icons.logout),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                // ทำการ logout
                authController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
