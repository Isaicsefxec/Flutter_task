import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Only this import is needed

class ArticleWebView extends StatefulWidget {
  final String url;

  const ArticleWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<ArticleWebView> createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('Loading: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },

          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // Load the initial URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Article'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload(); // Reload the WebView
            },
          ),
        ],
      ),
      body: WebViewWidget(
        controller: _controller, // Use the WebViewController
      ),
    );
  }
}