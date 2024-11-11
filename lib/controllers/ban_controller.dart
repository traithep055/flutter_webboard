import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BanController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var bannedUsers = <String>{}.obs;  // สร้าง Set สำหรับเก็บอีเมลของผู้ใช้ที่ถูกแบน
  var isLoading = false.obs;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // Ensure the key is 'accessToken'
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    // fetchBannedUsers();  // ดึงข้อมูลผู้ใช้ที่ถูกแบนตอนเริ่มต้น
  }

  // Fetch all users from API
  Future<void> fetchUsers() async {
    String? token = await _getToken();
    print("Token: $token");  // แสดง Token สำหรับดีบัก

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token หาย กรุณาล็อกอินใหม่');
      return;
    }
    
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.11.221:3001/user/alluser'),
        headers: {
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['users'] is List) {
          List<Map<String, dynamic>> usersList = List<Map<String, dynamic>>.from(data['users'].map((user) {
            if (user['role'] == 'USER') {
              return {
                'id': user['id'],
                'name': user['username'],
                'email': user['email'],
                'isBanned': false, // กำหนดค่าเริ่มต้น ถ้าต้องการอัพเดทสามารถทำได้
              };
            } else {
              return null;
            }
          }).where((user) => user != null));

          // ดึงข้อมูลผู้ใช้ที่ถูกแบนจาก API
          final bannedResponse = await http.get(
            Uri.parse('http://192.168.11.221:3001/user/banned'),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (bannedResponse.statusCode == 200) {
            final bannedData = jsonDecode(bannedResponse.body);
            List<String> bannedEmails = List<String>.from(bannedData['bannedUsers'].map((user) => user['email']));
            
            // ตรวจสอบสถานะการแบนและอัพเดตข้อมูล
            for (var user in usersList) {
              user['isBanned'] = bannedEmails.contains(user['email']);
            }

            users.assignAll(usersList);
          } else {
            print('ไม่สามารถโหลดข้อมูลผู้ใช้ที่แบนได้');
          }
        } else {
          print('รูปแบบข้อมูลไม่ถูกต้อง');
        }
      } else {
        print('ไม่สามารถโหลดข้อมูลผู้ใช้ได้');
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // Fetch banned users from API
  // Future<void> fetchBannedUsers() async {
  //   String? token = await _getToken();
  //   if (token == null || token.isEmpty) {
  //     Get.snackbar('Error', 'Token หาย กรุณาล็อกอินใหม่');
  //     return;
  //   }

  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://192.168.11.221:3001/user/banned'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       if (data['bannedUsers'] is List) {
  //         // Update the set of banned users
  //         bannedUsers.assignAll(data['bannedUsers'].map((user) => user['email'] as String));
  //         fetchUsers();  // Refresh the users list with updated banned status
  //       }
  //     } else {
  //       Get.snackbar('Error', 'ไม่สามารถดึงข้อมูลผู้ใช้ที่ถูกแบน');
  //     }
  //   } catch (e) {
  //     print('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้ที่ถูกแบน: $e');
  //   }
  // }

  // Ban or unban a user
  Future<void> banUser(String email) async {
  String? token = await _getToken();
  print("Token: $token");  // แสดง Token สำหรับดีบัก

  if (token == null || token.isEmpty) {
    Get.snackbar('Error', 'Token หาย กรุณาล็อกอินใหม่');
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://192.168.11.221:3001/user/ban'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'User has been banned successfully');
      fetchUsers();  // รีเฟรชรายการผู้ใช้หลังจากทำการแบน
    } else {
      Get.snackbar('Error', 'Failed to ban user');
    }
  } catch (e) {
    print('เกิดข้อผิดพลาดในการแบน: $e');
  }
}


  // Unban a user
  Future<void> unbanUser(String email) async {
    String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token หาย กรุณาล็อกอินใหม่');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.11.221:3001/user/unban'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User has been unbanned successfully');
        fetchUsers();  // รีเฟรชรายการผู้ใช้ที่ถูกแบนหลังจากทำการปลดแบน
      } else {
        Get.snackbar('Error', 'Failed to unban user');
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการปลดแบน: $e');
    }
  }

  // Toggle ban status of user
  void toggleBan(String id, String email) {
    int index = users.indexWhere((user) => user['id'] == id);
    if (index != -1) {
      bool currentStatus = users[index]['isBanned'] as bool;

      // Toggle local 'isBanned' flag
      users[index]['isBanned'] = !currentStatus;
      users.refresh();
      
      // Call API to ban or unban the user
      if (currentStatus) {
        unbanUser(email);  // ถ้าผู้ใช้ถูกแบนแล้ว ให้ปลดแบน
      } else {
        banUser(email);  // ถ้าผู้ใช้ไม่ได้แบน ให้แบน
      }
    }
  }
}
