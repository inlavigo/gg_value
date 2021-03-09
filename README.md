# GgValue - A simple value representation for Dart

GgValue represents a value in the memory of a dart application alongside with
the following features:

- A stream that provides updates on the value.
- A mechanism preventing many updates on multiple changes of the value.
- A custom transform function keeping the value in the desired range.
- A custom compare function, making sure only changes are delivered.
- A custom toString function to convert the value into a string
- A custom parse function converting strings into value

## Usage

```dart
void main() async {
  // ...........................
  // Get synchronously set value
  var v = GgValue<int>(seed: 5, spam: false);
  print('Sync: ${v.value}');

  // Outputs:
  // Sync: 5

  // ...........................
  // When spam is set to false, stream only delivers last change.
  v.spam = false;
  v.stream.listen((val) => print('Async: $val'));
  v.value = 1;
  v.value = 2;
  v.value = 3;
  await Future.delayed(Duration(microseconds: 1));

  // Outputs:
  // Async: 3

  // ...........................
  // When spam is set to true, stream delivers each change.
  v.spam = true;
  v.value = 7;
  v.value = 8;
  v.value = 9;
  await Future.delayed(Duration(microseconds: 1));

  // Outputs:
  // Async: 7
  // Async: 8
  // Async: 9

  // ..................................
  // Check or transform assigned values
  final ensureMaxFive = (int v) => v > 5 ? 5 : v;
  var v2 = GgValue<int>(seed: 0, transform: ensureMaxFive);
  v2.value = 4;
  print('Transformed: ${v2.value}');
  v2.value = 10;
  print('Transformed: ${v2.value}');
  await Future.delayed(Duration(microseconds: 1));

  // Outputs:
  // Transformed: 4
  // Transformed: 5

  // ...............................................
  // Deliver only updates, when values have changed.
  // The param 'isEqual' allows to specify an own comparison function.
  final haveSameFirstLetters =
      (String a, String b) => a.substring(0, 1) == b.substring(0, 1);

  var v3 = GgValue<String>(
    seed: 'Karl',
    compare: haveSameFirstLetters,
    spam: true,
  );

  final receivedUpdates = [];
  v3.stream.listen((val) => receivedUpdates.add(val));

  v3.value = 'Anna';
  v3.value = 'Arno';
  v3.value = 'Berta';
  v3.value = 'Bernd';

  await Future.delayed(Duration(microseconds: 1));

  print(receivedUpdates.join(', '));

  // Outputs:
  // Anna, Berta

  // .........................
  // Set and get string values
  var v4 = GgValue(seed: 0);
  v4.stringValue = '4';
  print(v4.value);
  print(v4.stringValue);

  // Outputs:
  // 4
  // 4

  // .............................................
  // Specify a custom parse and to string function
  int parseEm(String em) => int.parse(em.replaceAll('em', ''));
  String toEmString(int val) => '${val}em';
  var v5 = GgValue(seed: 0, parse: parseEm, toString: toEmString);
  v5.stringValue = '5em';
  print(v5.value);
  print(v5.stringValue);

  // Outputs:
  // 5
  // 5em
}

```

## Features and bugs

Please file feature requests and bugs at [GitHub](https://github.com/inlavigo/gg_value).

