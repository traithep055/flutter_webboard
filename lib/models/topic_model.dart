class TopicModel {
  final String? id;  // id is now nullable
  final String title;
  final String content;
  final String authorId;
  final String categoryId;

  TopicModel({
    this.id,  // id is now optional
    required this.title,
    required this.content,
    required this.authorId,
    required this.categoryId,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],  // id can now be null
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      categoryId: json['categoryId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'categoryId': categoryId,
    };
  }
}
