import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class ScriptRunner {
  final AssetBundle _bundle;
  final Logger _logger = Logger();

  ScriptRunner({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  Future<String> loadScript() async {
    try {
      return await _bundle.loadString('assets/simulation_tools.js');
    } catch (e) {
      _logger.e('Error loading script: $e');
      return '';
    }
  }
}
