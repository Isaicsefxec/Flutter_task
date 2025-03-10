import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsController {
  final String _apiKey = 'bb02cd0e88564bd29498b41993f8733d';

  Future<List<Article>> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$_apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articles = (data['articles'] as List)
          .map((json) => Article.fromJson(json))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
