import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());

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
            margin: const EdgeInsets.only(top: 20), // Add some top margin to give space from the app bar
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
                      backgroundImage: NetworkImage(_controller.user.value.profileImageUrl ?? ''),
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
                _buildTextField(
                  label: "ชื่อผู้ใช้:",
                  controller: TextEditingController(text: _controller.user.value.username),
                  onChanged: (value) => _controller.user.update((user) => user?.username = value),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  label: "อีเมล:",
                  controller: TextEditingController(text: _controller.user.value.email),
                  onChanged: (value) => _controller.user.update((user) => user?.email = value),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  label: "รหัสผ่าน:",
                  controller: TextEditingController(text: _controller.user.value.password),
                  obscureText: true,
                  onChanged: (value) => _controller.user.update((user) => user?.password = value),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _controller.updateProfile(context),
                  child: const Text("บันทึก"),
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

  // Helper method to build a text field with a label
  Widget _buildTextField({required String label, required TextEditingController controller, bool obscureText = false, required ValueChanged<String> onChanged}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
