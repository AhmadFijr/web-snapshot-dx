
import 'package:flutter/services.dart' show AssetBundle;

class ScriptRunner {
  final AssetBundle _assetBundle;

  ScriptRunner(this._assetBundle);

  Future<String> loadScript(String path) async {
    try {
      return await _assetBundle.loadString(path);
    } catch (e) {
      // ignore: avoid_print
      print('Error loading script: $e');
      return '';
    }
  }
}
