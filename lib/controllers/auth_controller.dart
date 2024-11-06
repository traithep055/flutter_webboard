import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isAuthenticated = false.obs;
  var isLoggedIn = false.obs;  // Track login status
  var userRole = ''.obs;

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

      // เก็บ role, accessToken และ refreshToken ลงใน SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);

      // อัพเดทค่า userRole และ isLoggedIn
      userRole.value = role;
      isLoggedIn.value = true; // เพิ่มบรรทัดนี้

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
    // ลบ tokens จาก SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    // อัปเดต isAuthenticated และ isLoggedIn
    isAuthenticated.value = false;
    isLoggedIn.value = false; // Set to false when logout
    userRole.value = ''; // Clear user role

    Get.offAllNamed('/home'); // หน้า login

    Get.snackbar('Logged out', 'คุณได้ออกจากระบบเรียบร้อย');
  }
}
