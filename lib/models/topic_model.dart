class TopicModel {
  final String? id;
  final String title;
  final String content;
  final String authorId;
  final String categoryId;
  final String? fileUrl; // เพิ่มฟิลด์สำหรับ URL ของไฟล์

  TopicModel({
    this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.categoryId,
    this.fileUrl, // กำหนดค่าเป็น null ได้ในกรณีไม่มีไฟล์
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      categoryId: json['categoryId'] as String,
      fileUrl: json['fileUrl'] as String?, // ตรวจสอบว่าเป็น null ได้
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'categoryId': categoryId,
      'fileUrl': fileUrl, // เพิ่มฟิลด์ fileUrl ในการแปลงเป็น JSON
    };
  }
}
