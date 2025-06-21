import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/services/script_runner.dart';

import 'script_runner_test.mocks.dart';

// This annotation generates script_runner_test.mocks.dart
@GenerateMocks([AssetBundle])
void main() {
  // Ensure the mockito code generation has been run
  // You might need to run: flutter pub run build_runner build
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('ScriptRunner', () {
    late MockAssetBundle mockAssetBundle;
    late ScriptRunner scriptRunner;

    setUp(() {
      mockAssetBundle = MockAssetBundle();
      // Pass the mock to the constructor for reliable testing
      scriptRunner = ScriptRunner(bundle: mockAssetBundle);
    });

    test('loadScript returns script content on success', () async {
      const scriptPath = 'assets/simulation_tools.js';
      const scriptContent = 'function test() {}';

      // Mock the behavior of loadString for our mock bundle
      when(mockAssetBundle.loadString(scriptPath))
          .thenAnswer((_) async => scriptContent);

      final result = await scriptRunner.loadScript();

      expect(result, scriptContent);
      verify(mockAssetBundle.loadString(scriptPath)).called(1);
    });

    test('loadScript returns empty string on failure', () async {
      const scriptPath = 'assets/simulation_tools.js';

      // Mock the behavior of loadString to throw an exception
      when(mockAssetBundle.loadString(scriptPath))
          .thenThrow(Exception('Failed to load asset'));

      final result = await scriptRunner.loadScript();

      expect(result, '');
      verify(mockAssetBundle.loadString(scriptPath)).called(1);
    });
  });
}
