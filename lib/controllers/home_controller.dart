import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post_model.dart';

class HomeController extends GetxController {
  var posts = <PostModel>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = 'หมวดหมู่'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    fetchCategories(); // โหลดหมวดหมู่ตอนเริ่มต้น
  }

  Future<void> fetchPosts({String? category}) async {
    try {
      String url = 'http://192.168.11.221:3001/post/posts';
      if (category != null && category != 'หมวดหมู่') {
        url += '?category=$category';
      }
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        posts.value = data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        print('Failed to load posts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.11.221:3001/category/categories'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        categories.value = ['หมวดหมู่', ...data.map((category) => category['name']).toList()];
      } else {
        print('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

