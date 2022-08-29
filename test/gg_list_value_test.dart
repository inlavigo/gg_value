// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:fake_async/fake_async.dart';
import 'package:gg_value/src/gg_list_value.dart';
import 'package:test/test.dart';

void main() {
  final GgListValue<int> listValue = GgListValue(seed: [0, 1, 2, 3]);

  void init() {
    listValue.reset();
  }

  void dispose() {}

  group('GgListValue', () {
    // #########################################################################
    group('add', () {
      test('should work correctly', () {
        fakeAsync((fake) {
          init();
          listValue.add(4);
          expect(listValue.value, [0, 1, 2, 3, 4]);
          dispose();
        });
      });

      test('should emit the right change', () {});
    });

    group('removeAt', () {
      test('should work correctly', () {
        fakeAsync((fake) {
          init();
          listValue.removeAt(3);
          expect(listValue.value, [0, 1, 2]);
          dispose();
        });
      });
    });

    group('remove', () {
      test('should work correctly', () {
        fakeAsync((fake) {
          init();
          listValue.remove(2);
          expect(listValue.value, [0, 1, 3]);
          dispose();
        });
      });
    });

    group('insertAfter', () {
      test('should work correctly', () {
        fakeAsync((fake) {
          init();

          listValue.insertAfter(10, 4);
          expect(listValue.value, [0, 1, 2, 3, 4]);

          listValue.reset();
          listValue.insertAfter(-10, -1);
          expect(listValue.value, [-1, 0, 1, 2, 3]);

          listValue.reset();
          listValue.insertAfter(0, 1);
          expect(listValue.value, [0, 1, 1, 2, 3]);

          listValue.reset();
          listValue.insertAfter(1, 2);
          expect(listValue.value, [0, 1, 2, 2, 3]);

          dispose();
        });
      });
    });

    test('insertBefore', () {
      fakeAsync((fake) {
        init();

        listValue.insertBefore(-10, -1);
        expect(listValue.value, [-1, 0, 1, 2, 3]);

        listValue.reset();
        listValue.insertBefore(0, -1);
        expect(listValue.value, [-1, 0, 1, 2, 3]);

        listValue.reset();
        listValue.insertBefore(2, 1);
        expect(listValue.value, [0, 1, 1, 2, 3]);

        listValue.reset();
        listValue.insertBefore(listValue.value.length, 4);
        expect(listValue.value, [0, 1, 2, 3, 4]);

        listValue.reset();
        listValue.insertBefore(100, 4);
        expect(listValue.value, [0, 1, 2, 3, 4]);

        dispose();
      });
    });
  });
}
