import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';

class ScriptRunner {
  final InAppWebViewController _controller;
  final Logger _logger = Logger();
  String? _simulationToolsJs;

  ScriptRunner(this._controller);

  Future<void> _loadJsFile() async {
    _simulationToolsJs ??= await rootBundle.loadString('assets/simulation_tools.js');
  }

  Future<void> injectJSScript() async {
    try {
      await _loadJsFile();
      if (_simulationToolsJs != null) {
        await _controller.evaluateJavascript(source: _simulationToolsJs!);
        _logger.i('Successfully injected simulation_tools.js');
      }
    } catch (e) {
      _logger.e('Error injecting JavaScript file: $e');
    }
  }

  Future<dynamic> runJsFunction(String functionCall) async {
    try {
      final result = await _controller.evaluateJavascript(source: functionCall);
      _logger.i('Executed JS function "$functionCall" with result: $result');
      return result;
    } catch (e) {
      _logger.e('Error running JS function "$functionCall": $e');
      return null;
    }
  }
}
