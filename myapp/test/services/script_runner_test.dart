import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/services/script_runner.dart';

import 'script_runner_test.mocks.dart';

// This annotation is used to generate the mock class.
@GenerateMocks([AssetBundle])
void main() {
  late ScriptRunner scriptRunner;
  late MockAssetBundle mockAssetBundle;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    // We inject the mock dependency directly into the class under test.
    scriptRunner = ScriptRunner(assetBundle: mockAssetBundle);
  });

  test('loadScript returns script content on success', () async {
    const scriptPath = 'assets/simulation_tools.js';
    const scriptContent = 'function test() {}';

    // Arrange: When the mock bundle is asked to load the string, return our fake content.
    when(mockAssetBundle.loadString(scriptPath))
        .thenAnswer((_) async => scriptContent);

    // Act: Call the method we are testing.
    final result = await scriptRunner.loadScript(scriptPath);

    // Assert: Verify that the result is what we expected.
    expect(result, scriptContent);
    // Also verify that the correct method was called on our mock.
    verify(mockAssetBundle.loadString(scriptPath)).called(1);
  });

  test('loadScript throws exception when asset is not found', () async {
    const nonExistentPath = 'assets/fake.js';

    // Arrange: Configure the mock to throw an exception.
    when(mockAssetBundle.loadString(nonExistentPath))
        .thenThrow(Exception('Asset not found'));

    // Act & Assert: Expect that calling the method throws an exception.
    expect(() => scriptRunner.loadScript(nonExistentPath), throwsA(isA<Exception>()));
    verify(mockAssetBundle.loadString(nonExistentPath)).called(1);
  });
}
