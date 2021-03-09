// @license
// Copyright (c) 2019 - 2021 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this repository.

import 'dart:async';

/// Represents a value of Type T in the memory.
class GgValue<T> {
  // ...........................................................................
  /// - [seed] The initial seed of the value.
  /// - If [spam] is true, each change of the value will be added to the
  ///   stream.
  /// - If [spam] is false, updates of the value are scheduled as micro
  ///   tasks. New updates are not added until the last update has been delivered.
  ///   Only the last set value will be delivered.
  /// - [transform] allows you to keep value in a given range or transform it.
  /// - [parse] is needed when [T] is not [String], [int], [double] or [bool].
  ///   It converts a string into [T].
  /// - [toString] is needed when [T] is not [String], [int], [double] or [bool].
  ///   It converts the value into a [String].
  GgValue({
    required T seed,
    this.spam = false,
    this.compare,
    this.transform,
    T Function(String)? parse,
    String Function(T)? toString,
  })  : _value = seed,
        _parse = parse,
        _toString = toString {
    _initController();
  }

  // ...........................................................................
  /// Sets the value and triggers an update on the stream.
  set value(T value) {
    if (value == _value) {
      return;
    }

    if (compare != null && compare!(value, _value)) {
      return;
    }

    _value = transform == null ? value : transform!(value);

    if (spam) {
      _controller.add(_value);
    } else if (!_isAlreadyTriggered) {
      _isAlreadyTriggered = true;
      scheduleMicrotask(() {
        _isAlreadyTriggered = false;
        if (_controller.hasListener) {
          _controller.add(_value);
        }
      });
    }
  }

  // ...........................................................................
  /// Parses [str] and writes the result into value.
  set stringValue(String str) {
    if (_parse != null) {
      value = _parse!.call(str);
    } else if (T == int) {
      value = int.parse(str) as T;
    } else if (T == double) {
      value = double.parse(str) as T;
    } else if (T == bool) {
      switch (str.toLowerCase()) {
        case 'false':
        case '0':
        case 'no':
          value = false as T;
          break;
        case 'true':
        case '1':
        case 'yes':
          value = true as T;
      }
    } else if (T == String) {
      value = str as T;
    } else {
      throw ArgumentError('Missing "parse" method for type "${T.toString()}".');
    }
  }

  // ...........................................................................
  /// Returns the [value] as [String].
  String get stringValue {
    if (_toString != null) {
      return _toString!.call(_value);
    } else if (T == String) {
      return _value as String;
    } else if (T == bool) {
      return (_value as bool) ? 'true' : 'false';
    } else if (T == int || T == double) {
      return _value.toString();
    } else {
      throw ArgumentError(
          'Missing "toString" method for unknown type "${T.toString()}".');
    }
  }

  // ...........................................................................
  /// Allows reducing the number of updates delivered when the value is changed
  /// multiple times.
  ///
  /// - If [spam] is true, each change of the value will be added to the stream.
  /// - If [spam] is false, updates of the value are scheduled as micro tasks.
  /// New updates are not added until the last update has been delivered.
  /// Only the last set value will be delivered.
  bool spam;

  // ...........................................................................
  /// If T is not a String or num, this function is used to parse a string

  // ...........................................................................
  /// Returns the value
  T get value => _value;

  /// Returns a stream informing about changes on the value
  Stream<T> get stream => _controller.stream;

  // ...........................................................................
  /// Call this method when the value is about to be released.
  void dispose() {
    _dispose.reversed.forEach((e) => e());
  }

  // ...........................................................................
  /// Is used to check if the value assigned is valid.
  final T Function(T)? transform;

  // ...........................................................................
  /// This operator compares to GgValue objects based on the value. When given,
  //the [compare] function is used to make the comparison.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GgValue<T> &&
          ((compare != null && compare!(_value, other._value)) ||
              _value == other._value);

  // ...........................................................................
  /// The hashcode of a GgValue is calculated based on the value.
  @override
  int get hashCode => _value.hashCode;

  // ######################
  // Private
  // ######################

  final List<Function()> _dispose = [];

  // ...........................................................................
  final StreamController<T> _controller = StreamController<T>.broadcast();
  void _initController() {
    _dispose.add(() => _controller.close());
  }

  // ...........................................................................
  T _value;

  // ...........................................................................
  bool _isAlreadyTriggered = false;

  // ...........................................................................
  final T Function(String)? _parse;

  // ...........................................................................
  final String Function(T)? _toString;

  // ...........................................................................
  /// Set a custom comparison operator
  final bool Function(T a, T b)? compare;
}
