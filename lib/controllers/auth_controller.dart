import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isAuthenticated = false.obs;

  final String registerUrl = 'http://192.168.11.221:3001/api/register';
  final String loginUrl = 'http://192.168.11.221:3001/api/login';

  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'สมัครสมาชิกเรียบร้อย');
      isAuthenticated.value = true;
      // Navigate to home or appropriate page
    } else {
      print('Registration failed: ${response.body}');
    }
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String role = data['role'] ?? '';
      String accessToken = data['accessToken'];
      String refreshToken = data['refreshToken'];

      // Store tokens in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);

      // Navigate based on role
      if (role == 'ADMIN') {
        Get.offNamed('/admindashboard');
      } else {
        Get.offNamed('/home');
      }

      Get.snackbar('Success', 'เข้าสู่ระบบสำเร็จ');
      isAuthenticated.value = true;
    } else {
      print('เข้าสู่ระบบไม่สำเร็จ: ${response.body}');
      Get.snackbar('Error', 'เข้าสู่ระบบไม่สำเร็จ: ${response.body}');
    }
  }

  Future<void> logout() async {
    // Clear tokens from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    // Update isAuthenticated and navigate to login page
    isAuthenticated.value = false;
    Get.offAllNamed('/home'); // Replace with your login route

    Get.snackbar('Logged out', 'คุณได้ออกจากระบบเรียบร้อย');
  }
}
