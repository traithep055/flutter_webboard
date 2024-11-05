// ที่ไหนสักแห่งในโปรเจคของคุณ
class PostModel {
  final String title;
  final String author;
  final String date;
  final String content;
  final String imageUrl;
  List<Map<String, String>> comments; // ฟิลด์สำหรับความคิดเห็น

  PostModel({
    required this.title,
    required this.author,
    required this.date,
    required this.content,
    required this.imageUrl,
    List<Map<String, String>>? comments, // รับค่าเริ่มต้น
  }) : comments = comments ?? []; // ถ้าไม่มีค่าจะใช้เป็นรายการว่าง
}
