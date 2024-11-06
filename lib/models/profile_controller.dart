// lib/controllers/profile_controller.dart
import 'package:get/get.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Observable UserModel for reactive UI updates
  var user = UserModel(
    username: "Josh",
    email: "Josh@test.com",
    password: "************",
    profileImageUrl: "https://example.com/profile-image.png", // Placeholder URL
  ).obs;

  // Method to handle profile image selection
  void selectProfileImage() {
    // Implement image selection logic here
    user.update((val) {
      val?.profileImageUrl = "https://new-image-url.com"; // Update with selected image
    });
  }

  // Method to handle profile update
  void updateProfile(BuildContext context) {
    // Implement profile update logic
    Get.snackbar("Success", "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM);
  }
}
