// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:math';

import '../gg_value.dart';

/// Represents a list value including special updates
class GgListValue<T> extends GgValue<List<T>> {
  // ...........................................................................
  GgListValue({
    super.seed = const [],
    super.spam,
    super.compare,
    super.transform,
    super.parse,
    super.stringify,
    super.name,
  });

  // ...........................................................................
  /// Adds a new item to the list
  void add(T newVal) {
    value = [...value, newVal];
  }

  // ...........................................................................
  /// Removes an item from the list
  void removeAt(int index) {
    value = [...value]..removeAt(index);
  }

  // ...........................................................................
  /// Removes the first occurence of the item
  void remove(T val) {
    value = [...value]..removeWhere(
        (element) => identical(element, val),
      );
  }

  // ...........................................................................
  /// Inserts a new value after a given index
  void insertAfter(int index, T newVal) {
    index = min(value.length - 1, index);
    index = max(-1, index);
    value = [...value]..insert(index + 1, newVal);
  }

  // ...........................................................................
  /// Inserts a new value before a given index
  void insertBefore(int index, T newVal) {
    index = min(value.length, index);
    index = max(0, index);

    value = [...value]..insert(index, newVal);
  }
}
