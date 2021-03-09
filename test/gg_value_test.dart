// @license
// Copyright (c) 2019 - 2021 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this repository.
import 'package:fake_async/fake_async.dart';
import 'package:gg_value/gg_value.dart';
import 'package:test/test.dart';

class Foo {}

void main() {
  // #########################################################################
  group('GgValue', () {
    late GgValue<int> v;
    void init() {
      v = GgValue(seed: 0);
    }

    // #########################################################################
    group('constructor', () {
      test('should be initialized with seed ', () {
        final nullVal = GgValue<int>(seed: 123);
        expect(nullVal.value, 123);
      });
    });

    // #########################################################################
    group('hashCode', () {
      test('should return the value\'s hashcode', () {
        final val = GgValue(seed: 'hello');
        expect(val.hashCode, val.value.hashCode);
      });
    });

    // #########################################################################
    group('dispose', () {
      test('should close the stream', () {
        fakeAsync((fake) {
          init();
          var isClosed = false;
          v.stream.listen(null, onDone: () => isClosed = true);
          fake.flushMicrotasks();
          expect(isClosed, false);
          v.dispose();
          fake.flushMicrotasks();
          expect(isClosed, true);
        });
      });
    });

    // #########################################################################
    group('value', () {
      test('should allow to set and get the value', () {
        init();
        const val = 172390;
        v.value = val;
        expect(v.value, val);
      });
    });

    // #########################################################################
    group('stringValue', () {
      test('should allow convert an int from and to a string', () {
        final intVal = GgValue(seed: 5);
        intVal.stringValue = '6';
        expect(intVal.value, 6);
        expect(intVal.stringValue, '6');
      });

      test('should allow convert a double from and to a string', () {
        final floatVal = GgValue(seed: 5.5);
        floatVal.stringValue = '6.6';
        expect(floatVal.value, 6.6);
        expect(floatVal.stringValue, '6.6');
      });

      test('should allow convert a string from and to a string', () {
        final stringVal = GgValue(seed: 'hello');
        stringVal.stringValue = 'world';
        expect(stringVal.value, 'world');
        expect(stringVal.stringValue, 'world');
      });

      test('should allow convert a bool from and to a string', () {
        final boolVal = GgValue(seed: false);
        expect(boolVal.stringValue, 'false');
        boolVal.stringValue = 'True';
        expect(boolVal.value, true);
        expect(boolVal.stringValue, 'true');
        boolVal.stringValue = 'no';
        expect(boolVal.value, false);
        boolVal.stringValue = 'yes';
        expect(boolVal.value, true);
        boolVal.stringValue = '0';
        expect(boolVal.value, false);
        boolVal.stringValue = '1';
        expect(boolVal.value, true);
      });

      test('should allow convert a custom type from and to a string', () {
        final foo0 = Foo();
        final foo1 = Foo();
        final fooVal =
            GgValue(seed: foo0, parse: (_) => foo1, toString: (_) => 'Foo3');
        expect(fooVal.value, foo0);
        fooVal.stringValue = 'Hey';
        expect(fooVal.value, foo1);
        expect(fooVal.stringValue, 'Foo3');
      });

      test(
          'should throw an exception if no parse method is provided for a custom function',
          () {
        final customVal = GgValue(seed: Foo());

        expect(
          () => customVal.stringValue = 'hello',
          throwsA(
            predicate((ArgumentError e) {
              expect(e.message, 'Missing "parse" method for type "Foo".');
              return true;
            }),
          ),
        );
      });

      test(
          'should throw an exception if no toString method is provided for a custom function',
          () {
        final customVal = GgValue(seed: Foo(), parse: (_) => Foo());

        expect(
          () => customVal.stringValue,
          throwsA(
            predicate((ArgumentError e) {
              expect(e.message,
                  'Missing "toString" method for unknown type "Foo".');
              return true;
            }),
          ),
        );
      });
    });

    // #########################################################################
    group('spam', () {
      test(
          'If spam is set to false, only the last of multiple synchronous value'
          'changes should be delivered', () {
        fakeAsync((fake) {
          init();

          v.spam = false;

          final receivedChanges = [];
          final s = v.stream.listen((value) => receivedChanges.add(value));
          fake.flushMicrotasks();
          expect(receivedChanges, []);
          v.value = 5;
          v.value = 6;
          v.value = 7;
          fake.flushMicrotasks();
          expect(receivedChanges, [7]);

          s.cancel();
        });
      });

      test(
          'If spam is set to true, all synchronous value changes should be'
          'delivered', () {
        fakeAsync((fake) {
          init();

          v.spam = true;

          final receivedChanges = [];
          final s = v.stream.listen((value) => receivedChanges.add(value));
          fake.flushMicrotasks();
          expect(receivedChanges, []);
          v.value = 5;
          v.value = 6;
          v.value = 7;
          fake.flushMicrotasks();
          expect(receivedChanges, [5, 6, 7]);

          s.cancel();
        });
      });
    });

    // #########################################################################
    group('transform', () {
      test('should apply a given transform function to a set value', () {
        final ensureMaxFive = (int v) => v > 5 ? 5 : v;
        var v2 = GgValue<int>(seed: 0, transform: ensureMaxFive);
        v2.value = 4;
        expect(v2.value, 4);
        v2.value = 10;
        expect(v2.value, 5);
      });
    });

    // #########################################################################
    group('stream', () {
      test('should allow to observe changes of the state', () {
        fakeAsync((fake) {
          init();
          final receivedValues = [];
          final s = v.stream.listen((val) => receivedValues.add(val));
          fake.flushMicrotasks();
          expect(receivedValues, []);

          v.value = 5;
          fake.flushMicrotasks();
          expect(receivedValues, [5]);

          v.value = 6;
          fake.flushMicrotasks();
          expect(receivedValues, [5, 6]);

          s.cancel();
        });
      });

      test('should only inform when the value really changes', () {
        fakeAsync((fake) {
          init();
          final receivedValues = [];
          final s = v.stream.listen((val) => receivedValues.add(val));

          fake.flushMicrotasks();
          expect(receivedValues, []);

          v.value = 5;
          fake.flushMicrotasks();
          expect(receivedValues, [5]);

          v.value = 5;
          fake.flushMicrotasks();
          expect(receivedValues, [5]);

          s.cancel();
        });
      });

      test('should allow to listen multiple times', () {
        fakeAsync((fake) {
          init();
          var counter = 0;
          var expectedCounter = 0;
          var secondValue = 2;

          // Create and cancel a first subscription
          final s1 = v.stream.listen((event) => counter++);
          fake.flushMicrotasks();
          expect(counter, expectedCounter);
          v.value = secondValue;
          expectedCounter++;
          fake.flushMicrotasks();
          s1.cancel();

          // Wait a little
          expect(counter, expectedCounter);

          // Create and cancel a second subscription
          final s2 = v.stream.listen((event) => counter++);
          fake.flushMicrotasks();
          expect(counter, expectedCounter);
          s2.cancel();
        });
      });
    });

    // #########################################################################
    group('.operator==', () {
      test('should return true if the value is the same', () {
        expect(GgValue(seed: 123) == GgValue(seed: 123), true);
      });

      test('should return false if the value is not the same', () {
        expect(GgValue(seed: 123) == GgValue(seed: 456), false);
      });

      test('should use the isEqualFunc when provided in constructor', () {
        final haveSameFirstLetters =
            (String a, String b) => a.substring(0, 1) == b.substring(0, 1);

        var v3 = GgValue<String>(
          seed: 'Karl',
          compare: haveSameFirstLetters,
          spam: true,
        );

        v3.value = 'Anna';
        expect(v3.value, 'Anna');
        v3.value = 'Arno';
        expect(v3.value, 'Anna');
        v3.value = 'Berta';
        expect(v3.value, 'Berta');
        v3.value = 'Bernd';
        expect(v3.value, 'Berta');
      });
    });
  });
}
