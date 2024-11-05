import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';


class RegisterView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6332C6),
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent, width: 3),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomTextField(controller: usernameController, labelText: "ชื่อผู้ใช้"),
              const SizedBox(height: 10),
              CustomTextField(controller: emailController, labelText: "อีเมล"),
              const SizedBox(height: 10),
              CustomTextField(controller: passwordController, labelText: "รหัสผ่าน", obscureText: true),
              const SizedBox(height: 10),
              CustomTextField(controller: confirmPasswordController, labelText: "ยืนยันรหัสผ่าน", obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (passwordController.text == confirmPasswordController.text) {
                    // Call the register function from AuthController
                    authController.register(
                      usernameController.text,
                      emailController.text,
                      passwordController.text,
                    );
                  } else {
                    Get.snackbar('Error', 'รหัสผ่านไม่ตรงกัน'); // Passwords do not match
                  }
                },
                child: const Text("สมัครสมาชิก", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.brown[100],
      ),
    );
  }
}
