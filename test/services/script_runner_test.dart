
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/services/script_runner.dart';

import 'script_runner_test.mocks.dart';

@GenerateMocks([AssetBundle])
void main() {
  group('ScriptRunner', () {
    late MockAssetBundle mockAssetBundle;
    late ScriptRunner scriptRunner;

    setUp(() {
      mockAssetBundle = MockAssetBundle();
      scriptRunner = ScriptRunner(mockAssetBundle);
    });

    test('loadScript returns script content on success', () async {
      const scriptPath = 'assets/simulation_tools.js';
      const scriptContent = 'function test() {}';

      when(mockAssetBundle.loadString(scriptPath))
          .thenAnswer((_) async => scriptContent);

      final result = await scriptRunner.loadScript(scriptPath);

      expect(result, scriptContent);
      verify(mockAssetBundle.loadString(scriptPath)).called(1);
    });

    test('loadScript returns empty string on failure', () async {
      const scriptPath = 'assets/non_existent_script.js';

      when(mockAssetBundle.loadString(scriptPath))
          .thenThrow(Exception('File not found'));

      final result = await scriptRunner.loadScript(scriptPath);

      expect(result, '');
      verify(mockAssetBundle.loadString(scriptPath)).called(1);
    });
  });
}
