import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isAuthenticated = false.obs;
  var isLoggedIn = false.obs;  // Track login status
  var userRole = ''.obs;
  var currentUserId = ''.obs;  // Variable to store the current user's ID

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
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        
        // Ensure key names match the response JSON structure
        String role = data['role'] ?? '';
        String accessToken = data['accessToken'];
        String refreshToken = data['refreshToken'];
        String userId = data['userid'];  // Updated key name to match response

        // Save user details in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('userId', userId);  // Save userId in SharedPreferences

        // Update currentUserId
        currentUserId.value = userId;
        userRole.value = role;
        isLoggedIn.value = true; // Set login status to true

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
    } catch (e) {
      print('Error during login: $e');
      Get.snackbar('Error', 'เกิดข้อผิดพลาดในระหว่างเข้าสู่ระบบ');
    }
  }

  Future<void> logout() async {
    // Remove tokens and userId from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userId');  // Remove userId from SharedPreferences

    // Update authentication status
    isAuthenticated.value = false;
    isLoggedIn.value = false;
    currentUserId.value = '';  // Clear current user ID
    userRole.value = ''; // Clear user role

    Get.offAllNamed('/home'); // Navigate to login page

    Get.snackbar('Logged out', 'คุณได้ออกจากระบบเรียบร้อย');
  }
}
