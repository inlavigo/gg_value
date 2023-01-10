# Change Log

## 1.5

- Add `changeStream` providing detailed information about changes
- Add `GgListValue` incl. `add`, `removeAt`, `remove`, `insertAfter`, `insertBefore`, `move`.
- Add `isOk` callback to prevent assignments in the wrong range.
- Add `syncStream` to get a synchronous stream of events

## 1.3.6

- Add `sync` and `unsync` to sync multiple values with each other.
- Add `forceUpdate` to send the current value to listeners again

## 1.2.0

- `reset` can be called to set value back to seed

## 1.1.0

- `GgValue.stream.map` was added.
- In many cases, consumers of `GgValue` should only read but not write. To
  enforce this, `GgReadOnlyValue` is introduced.
- Instead of `Stream<T>`, `GgValue<T>` returns a `GgValueStream<T>`, which offers
  direct access to the last set value.
- `GgValue.stream.map` was added.
- Added `set jsonDecodedValue` to assign values decoded from json
- Added `get jsonDecodedValue` to assign values decoded from json
- Renamed `toString` constructor parameter into `stringify`.
- Added `toString()` method.
- Added optional `name` constructor parameter
- String processing is working for dynamic types also
- Fixed: Once `dispose` was called, instances of `GgValue` will not emit any
  updates anymore.

## 1.0.2

- When used with custom types, no `parse` and `toString` function needs to be
  specified. An exception will by thrown only `stringValue` is used.

## 1.0.1

- Parse an generate bool strings
- Updated documentation
- Provided example

## 1.0.0

- Parse strings into GgValue
- Turn GgValue into strings

## 0.0.9+4

- Moved source code to <https://github.com/inlavigo/gg_value>

## 0.0.9+2

- Fixed dart package conventions.

## 0.0.9+1

- Initial version.
