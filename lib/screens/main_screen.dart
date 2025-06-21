import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:myapp/services/script_runner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  InAppWebViewController? _webViewController;
  final TextEditingController _urlController = TextEditingController();
  final ScriptRunner _scriptRunner = ScriptRunner();
  String? _simulationScript;

  @override
  void initState() {
    super.initState();
    _scriptRunner.loadScript().then((script) {
      if (mounted) {
        setState(() {
          _simulationScript = script;
        });
      }
    });
    _urlController.text = "https://flutter.dev";
  }

  void _runSimulation() {
    if (_webViewController != null && _simulationScript != null) {
      _webViewController!.evaluateJavascript(source: _simulationScript!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('WebView is not ready or script is not loaded.')),
        );
      }
    }
  }

  void _loadUrlFromTextField() {
    final String url = _urlController.text.trim();
    if (url.isNotEmpty) {
      // Ensure URL has a scheme (e.g., http, https)
      var uri = WebUri(url);
      if (uri.scheme.isEmpty) {
        uri = WebUri('https://$url');
      }
      _webViewController?.loadUrl(
        urlRequest: URLRequest(url: uri),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Snapshot Tool'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _runSimulation,
            tooltip: 'Run Simulation',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter URL',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _loadUrlFromTextField(),
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _loadUrlFromTextField,
                ),
              ],
            ),
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(_urlController.text)),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) {
                if (url != null) {
                  if (mounted) {
                    // Update text field only if it's different to avoid cursor jumps
                    if (_urlController.text != url.toString()) {
                      setState(() {
                        _urlController.text = url.toString();
                      });
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
