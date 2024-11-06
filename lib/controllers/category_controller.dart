import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs; // Define isLoading variable
  final String apiUrl = 'http://192.168.11.221:3001/category/categories';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // Ensure the key is 'accessToken'
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    String? token = await _getToken();
    print("Token: $token");  // Log the token for debugging

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true); // Start loading
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        categories.assignAll(data.map((item) => CategoryModel.fromJson(item)).toList());
      } else if (response.statusCode == 401) {
        Get.snackbar('Error', 'Unauthorized. Please login again.');
      } else {
        Get.snackbar('Error', 'Failed to fetch categories');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }

  void addCategory(String name) async {
    String? token = await _getToken();

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true); // Start loading
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        final newCategory = CategoryModel.fromJson(json.decode(response.body));
        categories.add(newCategory);
        Get.snackbar('Success', 'Category created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create category');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }

  void editCategory(String id, String name) async {
    String? token = await _getToken();

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true); // Start loading
    try {
      // ใช้ URL ที่ถูกต้องสำหรับการอัปเดตหมวดหมู่
      final response = await http.put(
        Uri.parse('http://192.168.11.221:3001/category/categories/$id'), // แก้ไข URL ให้ถูกต้อง
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name, // ส่งชื่อหมวดหมู่ใหม่ที่ต้องการอัปเดต
        }),
      );

      // ตรวจสอบสถานะของการตอบกลับจาก API
      if (response.statusCode == 200) {
        // อัปเดตข้อมูลใน local storage หากการตอบกลับสำเร็จ
        int index = categories.indexWhere((category) => category.id == id); // ใช้ id ในการค้นหาหมวดหมู่
        if (index != -1) {
          // อัปเดตหมวดหมู่ในรายการ categories
          categories[index] = CategoryModel.fromJson(json.decode(response.body));
          Get.snackbar('Success', 'Category updated successfully');
        }
      } else {
        // แสดงข้อผิดพลาดหากการอัปเดตไม่สำเร็จ
        Get.snackbar('Error', 'Failed to update category: ${response.body}');
      }
    } catch (e) {
      // แสดงข้อผิดพลาดที่เกิดขึ้น
      Get.snackbar('Error', 'Error occurred: ${e.toString()}');
      print('Error occurred: $e'); // ล็อกข้อผิดพลาดในคอนโซลเพื่อการดีบัก
    } finally {
      isLoading(false); // หยุดการโหลด
    }
  }

  void deleteCategory(String id) async {
    String? token = await _getToken();

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true); // Start loading
    try {
      // Make the API request to delete the category
      final response = await http.delete(
        Uri.parse('http://192.168.11.221:3001/category/categories/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the response is successful (HTTP 200), remove the category from the local list
        categories.removeWhere((category) => category.id == id); // Remove category by id
        Get.snackbar('Success', 'Category deleted successfully');
      } else if (response.statusCode == 401) {
        // If the user is unauthorized, ask them to login again
        Get.snackbar('Error', 'Unauthorized. Please login again.');
      } else {
        // If something went wrong with the request, show an error
        Get.snackbar('Error', 'Failed to delete category');
      }
    } catch (e) {
      // Handle any exceptions or errors that occur
      Get.snackbar('Error', 'Error occurred: ${e.toString()}');
    } finally {
      isLoading(false); // Stop loading
    }
  }
}