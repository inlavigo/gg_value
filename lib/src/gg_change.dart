// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

part of 'gg_value.dart';

enum GgChangeType {
  add,
  remove,
  insert,
  update,
}

class GgChange<T> {
  GgChange({
    required this.newValue,
    required this.oldValue,
    required this.type,
    this.index = -1,
  });

  final GgChangeType type;
  final T newValue;
  final T oldValue;
  final int index;
}
