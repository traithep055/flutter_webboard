import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/home_controller.dart';
import 'controllers/auth_controller.dart'; // เพิ่มการนำเข้า AuthController
import 'route/app_pages.dart';

void main() {
  Get.put(HomeController());  // ใช้ Get.put เพื่อให้ HomeController พร้อมใช้งาน
  Get.put(AuthController());  // ใช้ Get.put เพื่อให้ AuthController พร้อมใช้งาน

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Web Board',
      initialRoute: '/home',  // กำหนด route เริ่มต้น
      getPages: AppPages.routes,  // กำหนด routes ที่ใช้ในแอป
    );
  }
}
