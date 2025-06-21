import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as path;

class ScriptRunner {
  Future<void> execute(InAppWebViewController controller) async {
    try {
      final script =
          await rootBundle.loadString(path.join('assets', 'simulation_tools.js'));
      await controller.evaluateJavascript(source: script);
    } catch (e) {
      // Handle potential errors, e.g., script not found
      print('Error executing script: $e');
    }
  }
}
