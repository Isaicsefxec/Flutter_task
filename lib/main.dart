import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'WebViewscreen.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'News App',
      theme: themeProvider.themeData,
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  ThemeData get themeData => _themeMode == ThemeMode.light ? ThemeData.light() : ThemeData.dark();

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thanks for logging in!',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.green, // Green background
          behavior: SnackBarBehavior.floating, // Floating effect (optional)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners (optional)
          ),
        ),
      );
      // Navigate to NewsFeedPage after a short delay
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsFeedPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email TextField with Animation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: -0.5, curve: Curves.easeOut),
                    SizedBox(height: 5),

                  ],
                ),
                SizedBox(height: 20),

                // Password TextField with Animation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: 0.5, curve: Curves.easeOut),
                    SizedBox(height: 5),

                  ],
                ),
                SizedBox(height: 20),

                // Login Button with Animation
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: 0.5, curve: Curves.easeOut),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  List<dynamic> _articles = [];
  List<dynamic> _filteredArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }
  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=bb02cd0e88564bd29498b41993f8733d'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _articles = data['articles'];
          _filteredArticles = _articles;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load news: $e')),
      );
    }
  }
  void _filterNews(String query) {
    setState(() {
      _filteredArticles = _articles
          .where((article) =>
          article['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('News Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(_articles, _filterNews),
              );
            },
          ),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('We are processing...')
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 500.ms)
                .then(delay: 500.ms)
                .fadeOut(duration: 500.ms),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchNews,
        child: ListView.builder(
          itemCount: _filteredArticles.length,
          itemBuilder: (context, index) {
            final article = _filteredArticles[index];
            return NewsCard(
              id: index,
              title: article['title'],
              description: article['description'] ?? 'No description',
              imageUrl: article['urlToImage'] ?? '',
              source: article['source']['name'],
              publishedAt: article['publishedAt'],
              content: article['content'] ?? '',
              url: article['url'], // Pass the URL here
            );
          },
        ),
      ),
    );
  }
}
class NewsCard extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  final String content;
  final String url; // Add this field

  NewsCard({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.content,
    required this.url, // Add this field
  });

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
              builder: (context) => ArticleWebView(url: url), // Open WebView
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) {
                    print('Image load error: $error');
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),
              )
            else
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, size: 50),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        source,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Spacer(),
                      Text(
                        DateFormat('MMM dd, yyyy').format(DateTime.parse(publishedAt)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.5);
  }
}
class NewsDetailPage extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  final String content;

  NewsDetailPage({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Logout?'),
            content: Text('Do you want to go Back?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('News Detail'),
          actions: [
            IconButton(
              icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty && Uri.parse(imageUrl).isAbsolute)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) {
                      print('Image load error: $error'); // Debugging
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, size: 50),
                      );
                    },
                  ),
                ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    source,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('MMM dd, yyyy').format(DateTime.parse(publishedAt)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> articles;
  final Function(String) filterNews;

  NewsSearchDelegate(this.articles, this.filterNews);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = articles
        .where((article) =>
        article['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return ListTile(
          title: Text(article['title']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(
                  id: index,
                  title: article['title'],
                  description: article['description'] ?? 'No description',
                  imageUrl: article['urlToImage'] ?? '',
                  source: article['source']['name'],
                  publishedAt: article['publishedAt'],
                  content: article['content'] ?? '',
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? articles
        : articles
        .where((article) =>
        article['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final article = suggestions[index];
        return ListTile(
          title: Text(article['title']),
          onTap: () {
            query = article['title'];
            showResults(context);
          },
        );
      },
    );
  }
}
