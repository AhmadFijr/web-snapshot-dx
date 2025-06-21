import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';
import 'package:myapp/services/script_runner.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  ScriptRunner? _scriptRunner;
  final Logger _logger = Logger();
  final TextEditingController _urlController = TextEditingController();

  Uri _initialUrl = Uri.parse("https://www.google.com");

  @override
  void initState() {
    super.initState();
    _urlController.text = _initialUrl.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Desktop Browser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController?.reload();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.go_to_page),
                  onPressed: () {
                    final text = _urlController.text;
                    if (Uri.tryParse(text) != null) {
                       setState(() {
                         _initialUrl = Uri.parse(text);
                       });
                       _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri.uri(_initialUrl)));
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                 if (Uri.tryParse(value) != null) {
                    setState(() {
                      _initialUrl = Uri.parse(value);
                    });
                    _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri.uri(_initialUrl)));
                 }
              },
            ),
          ),
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri.uri(_initialUrl)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
                _scriptRunner = ScriptRunner(controller);
              },
              onLoadStop: (controller, url) async {
                if (url != null) {
                  _urlController.text = url.toString();
                }
                _logger.i('Page finished loading: $url');
                await _scriptRunner?.injectJSScript();
              },
              onConsoleMessage: (controller, consoleMessage) {
                _logger.d("[WebView] ${consoleMessage.message}");
              },
               shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url;

                if (uri != null && !["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                        return NavigationActionPolicy.CANCEL;
                    }
                }

                return NavigationActionPolicy.ALLOW;
            },
            ),
          ),
        ],
      ),
    );
  }
}
