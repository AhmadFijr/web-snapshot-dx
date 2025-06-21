import 'package:flutter/services.dart';

/// A service to load script files from assets.
class ScriptRunner {
  final AssetBundle _assetBundle;

  /// Creates a script runner.
  ///
  /// If [assetBundle] is not provided, it defaults to [rootBundle].
  ScriptRunner({AssetBundle? assetBundle}) : _assetBundle = assetBundle ?? rootBundle;

  /// Loads a script from the given asset path using the configured asset bundle.
  ///
  /// Throws an exception if the asset is not found.
  Future<String> loadScript(String path) async {
    return await _assetBundle.loadString(path);
  }
}
