import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CommentController extends GetxController {
  var isLoading = false.obs;


  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> addComment(String content, String authorId, String postId) async {
    String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true);
    final url = Uri.parse('http://192.168.11.221:3001/comment/comments');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "content": content,
          "authorId": authorId,
          "postId": postId,
        }),
      );

      if (response.statusCode == 200) {
        print("Comment added successfully");
        // Handle success response if needed
      } else {
        print("Failed to add comment: ${response.statusCode}");
        // Handle error response if needed
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
