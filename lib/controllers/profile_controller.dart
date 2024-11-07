import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  var user = UserModel().obs;
  final String apiUrl = 'http://192.168.11.221:3001/user/users';
  final String baseUrl = 'http://192.168.11.221:8080';
  File? selectedImage;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
  
  Future<void> fetchUserData() async {
    String? token = await _getToken();
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        user.value = UserModel(
          username: data['username'],
          email: data['email'],
          password: "********",
          profileImageUrl: data['photoUrl'] != null
              ? '$baseUrl${data['photoUrl']}'
              : 'https://example.com/default-image.png',
        );
      } else {
        Get.snackbar("Error", "Failed to load user data",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> selectProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      selectedImage = File(result.files.single.path!);
      user.update((val) {
        val?.profileImageUrl = selectedImage!.path;
      });
    }
  }

  Future<void> updateProfileWithImage(BuildContext context, String username, String email, String password) async {
    String? token = await _getToken();
    if (token == null) return;

    try {
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['password'] = password;

      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('file', selectedImage!.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully", snackPosition: SnackPosition.BOTTOM);
        fetchUserData(); // Refresh user data after update
      } else {
        Get.snackbar("Error", "Failed to update profile", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
