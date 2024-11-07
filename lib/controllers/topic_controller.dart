import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topic_model.dart';
import 'dart:io'; // For File

class TopicController extends GetxController {
  var topics = <TopicModel>[].obs;
  var categories = <Map<String, String>>[].obs; // Store categories with name and id
  var isLoading = false.obs;
  final String apiUrl = 'http://192.168.11.221:3001/post/posts';
  final String categoryApiUrl = 'http://192.168.11.221:3001/category/categories';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  void onInit() {
    super.onInit();
    fetchTopics(); // Fetch topics when the controller is initialized
    fetchCategories(); // Fetch categories when the controller is initialized
  }

  Future<void> fetchTopics() async {
    String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('http://192.168.11.221:3001/post/posts/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        topics.value = data.map((item) => TopicModel.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'คุณยังไม่มีกระทู้');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse(categoryApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        categories.value = data.map((item) => {
          'id': item['id'] as String,
          'name': item['name'] as String
        }).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch categories');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTopic(
    String title, String content, String authorId, String categoryId, File? file) async {
    String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token is missing. Please login again.');
      return;
    }

    isLoading(true);
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['title'] = title
        ..fields['content'] = content
        ..fields['authorId'] = authorId
        ..fields['categoryId'] = categoryId;

      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await http.Response.fromStream(response);
        final data = jsonDecode(responseData.body);
        final newTopic = TopicModel.fromJson(data);
        topics.add(newTopic);
        topics.refresh();
      } else {
        Get.snackbar('Error', 'Failed to add topic: ${response.reasonPhrase}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

Future<void> editTopic(String topicId, String title, String content, String categoryId, File? file) async {
  String? token = await _getToken();
  if (token == null || token.isEmpty) {
    Get.snackbar('Error', 'Token is missing. Please login again.');
    return;
  }

  isLoading(true);
  try {
    var uri = Uri.parse('http://192.168.11.221:3001/post/posts/$topicId');
    var request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['content'] = content
      ..fields['categoryId'] = categoryId;

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      final updatedTopic = TopicModel.fromJson(data);

      int index = topics.indexWhere((topic) => topic.id == topicId);
      if (index != -1) {
        topics[index] = updatedTopic;
        topics.refresh();
      }
    } else {
      Get.snackbar('Error', 'Failed to edit topic: ${response.reasonPhrase}');
    }
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading(false);
  }
}


Future<void> deleteTopic(String topicId) async {
  String? token = await _getToken();
  if (token == null || token.isEmpty) {
    Get.snackbar('Error', 'Token is missing. Please login again.');
    return;
  }

  isLoading(true);
  try {
    final response = await http.delete(
      Uri.parse('http://192.168.11.221:3001/post/posts/$topicId'), // Replace with correct URL
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successfully deleted, now remove the topic from the list
      topics.removeWhere((topic) => topic.id == topicId);
      topics.refresh(); // Refresh the list to update UI
    } else {
      Get.snackbar('Error', 'Failed to delete topic: ${response.body}');
    }
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading(false);
  }
}


}
