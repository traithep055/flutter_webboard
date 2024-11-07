import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post_model.dart';

class HomeController extends GetxController {
  var posts = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.11.221:3001/post/posts'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        print(data);  // เพิ่มการพิมพ์ข้อมูลที่ได้รับจาก API
        posts.value = data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        print('Failed to load posts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
