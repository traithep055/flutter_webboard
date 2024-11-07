import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/comment_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart'; // Import the AuthController
import '../controllers/topic_controller.dart';
import '../controllers/profile_controller.dart';
import '../views/admin/category/addcategory_page.dart';
import '../views/admin/category/category_page.dart';
import '../views/admin/category/editcategory_page.dart';
import '../views/admin/dashboard.dart';
import '../views/admin/profile.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home_view.dart';
import '../views/user/dashboard.dart';
import '../views/user/topic/addtopic.dart';
import '../views/user/topic/edittopic.dart';
import '../views/user/topic/topic_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController()); // Use Get.lazyPut to create HomeController only when accessing HomeView
        Get.lazyPut(() => CommentController());
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
      name: '/profile',
      page: () => ProfilePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileController());
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
    GetPage(
      name: '/userdashboard',
      page: () => UserDashboard(),
    ),
    GetPage(
      name: '/topic',
      page: () => TopicPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TopicController());
      }),
    ),
    GetPage(
      name: '/addtopic',
      page: () => AddTopicPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TopicController());
      }),
    ),
    GetPage(
      name: '/edittopic',
      page: () => EditTopicPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TopicController());
      }),
    ),
  ];
}
