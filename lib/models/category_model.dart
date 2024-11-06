class CategoryModel {
  final String id; // เพิ่ม id เป็นฟิลด์
  final String name;

  CategoryModel({required this.id, required this.name});

  // ตัวอย่างฟังก์ชันจาก JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'], // ตรวจสอบว่า JSON มี key 'id'
      name: json['name'],
    );
  }
}
