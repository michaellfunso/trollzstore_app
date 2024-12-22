import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewWithNavigation(),
    );
  }
}

class WebViewWithNavigation extends StatefulWidget {
  @override
  _WebViewWithNavigationState createState() => _WebViewWithNavigationState();
}

class _WebViewWithNavigationState extends State<WebViewWithNavigation> {
  late WebViewController _webViewController;

  // URLs for navigation buttons
  final Map<String, String> _urls = {
    'Home': 'https://trollzstore.com.ng/',
    'Categories': 'https://trollzstore.com.ng/products-grid.php?cat=Causuals',
    'Contact': 'https://trollzstore.com.ng/contact.php',
    'Profile': 'https://trollzstore.com.ng/login.php',
  };

  // Current selected index in the navigation bar
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Add a loading bar or spinner
            print('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error loading page: $error');
          },
        ),
      )
      ..loadRequest(Uri.parse(_urls['Home']!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trollz Store'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: WebViewWidget(controller: _webViewController),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          String selectedKey = _urls.keys.elementAt(index);
          _webViewController.loadRequest(Uri.parse(_urls[selectedKey]!));
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail_rounded),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
