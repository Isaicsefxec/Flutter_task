import 'package:flutter/material.dart';
import '../../models/news_article.dart';
import '../news_detail_page.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(article.imageUrl, height: 150, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                article.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
