import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../services/script_runner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  late final TextEditingController _urlController;
  late final String _simulationScript;

  bool _isLoading = true;
  String _currentUrl = "https://flutter.dev";

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: _currentUrl);
    _loadSimulationScript();
  }

  Future<void> _loadSimulationScript() async {
    _simulationScript = await ScriptRunner.loadScript();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _navigateToPage() {
    final newUrl = _urlController.text;
    if (newUrl.isNotEmpty && _webViewController != null) {
      _webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(newUrl)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Snapshot'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter URL',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onSubmitted: (_) => _navigateToPage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _navigateToPage,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(_currentUrl)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
                _currentUrl = url.toString();
                _urlController.text = _currentUrl;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
              // Inject the script once the page is loaded
              await _webViewController?.evaluateJavascript(source: _simulationScript);
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
