import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain does not import Flutter, Dio, go_router, or pigeon output', () {
    final domain = Directory('lib/domain');
    expect(domain.existsSync(), isTrue);

    final forbidden = <RegExp>[
      RegExp(r'package:flutter/'),
      RegExp(r'package:flutter_riverpod/'),
      RegExp(r'package:dio/'),
      RegExp(r'package:go_router/'),
      RegExp(r'package:hg_native/'),
      RegExp(r'native_api\.g\.dart'),
    ];

    final violations = <String>[];
    for (final file in domain.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) {
        continue;
      }
      final source = file.readAsStringSync();
      for (final pattern in forbidden) {
        if (pattern.hasMatch(source)) {
          violations.add('${file.path} matches ${pattern.pattern}');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
