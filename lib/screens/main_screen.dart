
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:myapp/services/script_runner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _urlController =
      TextEditingController(text: 'https://flutter.dev');
  InAppWebViewController? _webViewController;
  final ScriptRunner _scriptRunner = ScriptRunner(rootBundle);
  String? _simulationScript;

  @override
  void initState() {
    super.initState();
    _loadSimulationScript();
  }

  Future<void> _loadSimulationScript() async {
    final script = await _scriptRunner.loadScript('assets/simulation_tools.js');
    setState(() {
      _simulationScript = script;
    });
  }

  void _runInWebView(String code) {
    _webViewController?.evaluateJavascript(source: code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Snapshot'),
        elevation: 4,
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
                      labelText: 'Enter URL',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (url) {
                       _webViewController?.loadUrl(
                          urlRequest: URLRequest(url: WebUri(url)),
                       );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                     _webViewController?.loadUrl(
                          urlRequest: URLRequest(url: WebUri(_urlController.text)),
                       );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(_urlController.text),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) {
                if (_simulationScript != null) {
                  _runInWebView(_simulationScript!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
