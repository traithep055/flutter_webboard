class PostModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String authorName;
  final String categoryName;
  final String createdAt;
  final List<Map<String, String>> comments;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.authorName,
    required this.categoryName,
    required this.createdAt,
    List<Map<String, String>>? comments,
  }) : comments = comments ?? [];

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: 'http://192.168.11.221:8080${json['photoUrl']}',
      authorName: json['author']['username'],
      categoryName: json['category']['name'],
      createdAt: json['createdAt'],
      comments: (json['comments'] as List).map((comment) {
        return {
          'author': comment['author']?.toString() ?? 'Anonymous',
          'content': comment['content']?.toString() ?? ''
        };
      }).toList(),
    );
  }
}
