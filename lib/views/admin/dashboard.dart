import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class AdminDashboardView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController()); // หาค่าจาก GetX

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color(0xFF6332C6),
        child: Center(
          child: GridView.count(
            padding: const EdgeInsets.all(32),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              DashboardButton(
                color: Colors.green,
                icon: Icons.book,
                label: 'จัดการหมวดหมู่',
                onTap: () {
                  // Navigate to category management
                  Get.toNamed('/category');
                },
              ),
              DashboardButton(
                color: Colors.blue,
                icon: Icons.person,
                label: 'ข้อมูลส่วนตัว',
                onTap: () {
                  // Navigate to personal information
                },
              ),
              DashboardButton(
                color: Colors.yellow,
                icon: Icons.home,
                label: 'หน้าหลัก',
                onTap: () {
                  Get.toNamed('/home');
                },
              ),
              DashboardButton(
                color: Colors.red,
                icon: Icons.logout,
                label: 'Logout',
                onTap: () async {
                  await authController.logout(); // เรียกฟังก์ชัน logout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DashboardButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
