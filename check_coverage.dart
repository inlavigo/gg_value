#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

Future<void> main(List<String> arguments) async {
  // Remove the coverage directory
  var coverageDir = Directory('coverage');
  if (await coverageDir.exists()) {
    await coverageDir.delete(recursive: true);
  }

  // Run the Dart coverage command
  var testResult =
      await Process.run('dart', ['run', 'coverage:test_with_coverage']);
  if (testResult.exitCode != 0) {
    print('❌ Tests failed with exit code: ${testResult.exitCode}');
    exit(testResult.exitCode);
  }

  // Run genhtml command
  var genhtmlResult = await Process.run(
    'genhtml',
    ['coverage/lcov.info', '-o', 'coverage/html'],
  );
  var resultOutput = genhtmlResult.stdout.toString();

  // Open coverage report conditionally
  if (arguments.isNotEmpty) {
    await Process.run('open', ['coverage/html/src/index.html']);
  }

  // Parse coverage percentage
  var coverageMatch =
      RegExp(r'lines......: ([0-9]*\.[0-9]*)%').firstMatch(resultOutput);
  var percentage = coverageMatch?.group(1) ?? '0';

  // Check coverage percentage
  if (percentage != '100.0') {
    print('❌ Coverage is only $percentage%!');
    exit(1);
  } else {
    print('✅ Coverage is 100%!');
    exit(0);
  }
}
