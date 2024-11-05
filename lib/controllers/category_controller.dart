import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  // Sample categories list
  var categories = <CategoryModel>[
    CategoryModel(name: 'หนังพจญภัย'),
    CategoryModel(name: 'หนังตลก'),
    CategoryModel(name: 'หนังผี'),
  ].obs;

  void addCategory(String name) {
    categories.add(CategoryModel(name: name));
  }

  void editCategory(int index, String name) {
    categories[index] = CategoryModel(name: name);
  }

  void deleteCategory(int index) {
    categories.removeAt(index);
  }
}
