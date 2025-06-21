import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/services/script_runner.dart';

void main() {
  // This is necessary to use rootBundle in tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // This is a common pattern to ensure the asset is available for the test.
    // The path here must match the path in your pubspec.yaml assets section.
    // We create a mock for the asset bundle to return our expected script content.
    ServicesBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (MethodCall methodCall) async {
      if (methodCall.method == 'getAssetBundle') {
        return null;
      }
      final String key = methodCall.arguments;
      // Provide a mock response for the specific asset being loaded.
      if (key == 'assets/simulation_tools.js') {
        // Return the content of your JS file as a string.
        // For simplicity, we'll return a snippet. In a real scenario, you could load the file.
        return ByteData.sublistView(Uint8List.fromList('async function mouse_click_event'.codeUnits));
      }
      return null;
    });
  });

  tearDown(() {
    ServicesBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(const MethodChannel('flutter/assets'), null);
  });

  test('ScriptRunner loads script content successfully', () async {
    final scriptContent = await ScriptRunner.loadScript();
    
    // Verify that the loaded script is a string and contains expected content.
    expect(scriptContent, isA<String>());
    expect(scriptContent, contains('mouse_click_event'));
  });
}
