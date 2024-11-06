import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart'; // Import the AuthController
import '../views/admin/category/addcategory_page.dart';
import '../views/admin/category/category_page.dart';
import '../views/admin/category/editcategory_page.dart';
import '../views/admin/dashboard.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController()); // Use Get.lazyPut to create HomeController only when accessing HomeView
      }),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController()); // Bind AuthController for RegisterView
      }),
    ),
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController()); // Bind AuthController for LoginView
      }),
    ),
    GetPage(
      name: '/admindashboard',
      page: () => AdminDashboardView(), // No binding needed for AdminDashboardView
    ),
    GetPage(
      name: '/category',
      page: () => CategoryPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CategoryController());
      }),
    ),
    GetPage(
      name: '/addcategory',
      page: () => AddCategoryPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CategoryController());
      }),
    ),
    GetPage(
      name: '/editcategory',
      page: () => EditCategoryPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CategoryController());
      }),
    ),
  ];
}
