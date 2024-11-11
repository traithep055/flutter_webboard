import 'package:get/get.dart';

class BanController extends GetxController {
  // ตัวอย่างข้อมูลผู้ใช้
  var users = <Map<String, dynamic>>[
    {'id': 1, 'name': 'User 1', 'isBanned': false},
    {'id': 2, 'name': 'User 2', 'isBanned': false},
    {'id': 3, 'name': 'User 3', 'isBanned': true},
  ].obs;

  // ฟังก์ชันสำหรับแบนหรือปลดแบนผู้ใช้
  void toggleBan(int id) {
    var index = users.indexWhere((user) => user['id'] == id);
    if (index != -1) {
      users[index]['isBanned'] = !(users[index]['isBanned'] as bool); // แปลงเป็น bool ก่อนกลับค่าตรรกะ
      users.refresh(); // อัปเดต UI
    }
  }
}
