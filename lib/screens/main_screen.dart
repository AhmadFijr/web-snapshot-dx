
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:myapp/services/script_runner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late InAppWebViewController _webViewController;
  final ScriptRunner _scriptRunner = ScriptRunner();
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Snapshot Tool'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController.reload();
            },
          ),
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
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    final url = _urlController.text;
                    if (url.isNotEmpty) {
                      _webViewController.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(url),
                        ),
                      );
                    }
                  },
                ),
              ),
              onSubmitted: (url) {
                if (url.isNotEmpty) {
                  _webViewController.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri(url),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("https://flutter.dev"),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) {
                _scriptRunner.executeScript(
                    controller, 'assets/simulation_tools.js');
                if (url != null) {
                  _urlController.text = url.toString();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
