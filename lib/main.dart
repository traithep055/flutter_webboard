import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/home_controller.dart';
import 'route/app_pages.dart';

void main() {
  Get.put(HomeController()); // สร้าง HomeController ที่นี่
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Web Board',
      initialRoute: '/home',
      getPages: AppPages.routes,
    );
  }
}
