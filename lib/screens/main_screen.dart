import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:myapp/services/script_runner.dart';

class MainScreen extends StatefulWidget {
  final ScriptRunner scriptRunner;

  const MainScreen({Key? key, required this.scriptRunner}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  InAppWebViewController? _controller;
  final TextEditingController _urlController =
      TextEditingController(text: "https://flutter.dev");
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _loadUrl() {
    if (_controller != null && _urlController.text.isNotEmpty) {
      final url = Uri.tryParse(_urlController.text);
      if (url != null && (url.isScheme('http') || url.isScheme('https'))) {
        _controller!.loadUrl(urlRequest: URLRequest(url: WebUri.uri(url)));
      } else {
        // Handle invalid URL
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid URL.')),
        );
      }
    }
  }

  void _runScript() {
    if (_controller != null) {
      widget.scriptRunner.run(_controller!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Browser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _runScript,
            tooltip: 'Run Script',
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
                      labelText: 'Enter URL',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _loadUrl(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _loadUrl,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest:
                      URLRequest(url: WebUri(_urlController.text)),
                  onWebViewCreated: (controller) {
                    _controller = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      _isLoading = true;
                      _urlController.text = url.toString();
                    });
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
