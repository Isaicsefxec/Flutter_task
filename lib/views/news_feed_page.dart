import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/news_controller.dart';
import '../models/news_article.dart';
import 'widgets/news_card.dart';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  final NewsController _newsController = NewsController();
  late Future<List<Article>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsController.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Feed')),
      body: FutureBuilder<List<Article>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return NewsCard(article: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
