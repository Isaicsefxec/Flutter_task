// models/news_article.dart
class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  final String content;
  final String url;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.content,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      description: json['description'] ?? 'No description',
      imageUrl: json['urlToImage'] ?? '',
      source: json['source']['name'],
      publishedAt: json['publishedAt'],
      content: json['content'] ?? '',
      url: json['url'],
    );
  }
}