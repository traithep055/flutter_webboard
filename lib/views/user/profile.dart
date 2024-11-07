import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';


class UserProfilePage extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ProfilePage() {
    _controller.fetchUserData(); // Fetch user data on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโปรไฟล์'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 300,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => CircleAvatar(
                      radius: 40,
                      backgroundImage: _controller.selectedImage != null
                          ? FileImage(_controller.selectedImage!)
                          : NetworkImage(_controller.user.value.profileImageUrl ?? '') as ImageProvider,
                      child: _controller.user.value.profileImageUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    )),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _controller.selectProfileImage,
                  child: const Text("เลือกไฟล์"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  usernameController.text = _controller.user.value.username ?? "";
                  return _buildTextField(
                    label: "ชื่อผู้ใช้:",
                    controller: usernameController,
                  );
                }),
                const SizedBox(height: 8),
                Obx(() {
                  emailController.text = _controller.user.value.email ?? "";
                  return _buildTextField(
                    label: "อีเมล:",
                    controller: emailController,
                  );
                }),
                const SizedBox(height: 8),
                _buildTextField(
                  label: "รหัสผ่าน:",
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _controller.updateProfileWithImage(
                      context,
                      usernameController.text,
                      emailController.text,
                      passwordController.text,
                    );
                  },
                  child: const Text(
                    "บันทึก",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.purple[700],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
    );
  }
}
