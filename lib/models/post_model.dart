class PostModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String authorName;
  final String categoryName;
  final String createdAt;
  final List<Map<String, dynamic>> comments;  // เปลี่ยนเป็น List<Map<String, dynamic>>

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.authorName,
    required this.categoryName,
    required this.createdAt,
    List<Map<String, dynamic>>? comments,  // เปลี่ยนเป็น List<Map<String, dynamic>>
  }) : comments = comments ?? [];

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['photoUrl'] != null
          ? 'http://192.168.11.221:8080${json['photoUrl']}'
          : '', // Use an empty string if no photoUrl is provided
      authorName: json['author']['username'],
      categoryName: json['category']['name'],
      createdAt: json['createdAt'],
      comments: (json['comments'] as List).map((comment) {
        return {
          'author': comment['author']['username'] ?? 'Anonymous', // Use username from comment['author']
          'content': comment['content'] ?? ''
        };
      }).toList(),
    );
  }
}
