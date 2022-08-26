// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

part of 'gg_value.dart';

// #############################################################################
/// Synchronize a bunch of values
class GgSync<T> {
  /// [values] is the initial list of values to be synced.
  /// Additional values can be added using [_addValue] and [_removeValue].
  /// [seed] is the initial value that is synced to all values in the list.
  GgSync._({required GgValue<T> firstValue}) {
    _value = firstValue.value;
    _addValue(firstValue);
  }

  // ...........................................................................
  /// Add a value to be synced with previously added values.
  void _addValue(GgValue<T> value) {
    for (final other in values) {
      if (identical(other, value)) {
        return;
      }
    }

    values.add(value);
    assert(value._sync == null);
    value._sync = this;
    value._applySync(_value);
  }

  // ...........................................................................
  void _removeValue(GgValue<T> value) {
    if (!values.contains(value)) {
      return;
    }

    values.removeWhere((e) => identical(e, value));
    value._sync = null;

    if (values.length == 1) {
      _removeValue(values.first);
    }
  }

  // ...........................................................................
  final values = <GgValue<T>>[];

  // ...........................................................................
  set value(T val) {
    if (_value == val) {
      return;
    }

    _value = val;
    for (final v in values) {
      v._applySync(_value);
    }
  }

  // ######################
  // Private
  // ######################

  late T _value;
}
