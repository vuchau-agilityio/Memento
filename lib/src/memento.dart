/// Stores internal state of the [Originator] object.
///
/// There's a link between [Memento] and [Originator],
/// this connection allow to memento restore originator's internal state.
class Memento<T> {
  final T _state;
  final Originator<T> _originator;

  Memento(this._state, this._originator);

  void restore() => _originator.setState(_state);
}

/// Creates mementos based on its own internal state.
///
/// Implement this interface on your class that originate the data.
/// ```dart
/// class MyOriginator implements Originator<int>{
///   int counter = 0;
///
///   @override
///   Memento<int> save() => Memento(counter, this);
///
///   @override
///   void setState(T state) => counter = state;
/// }
///  ```
abstract class Originator<T> {
  Memento<T> save();
  void setState(T state);
}

/// Is reponsible for memento's safekeeping.
///
/// [Caretaker] allow restore [Originator] state without operates
/// on the content of memento.
/// Use [Caretaker] on client-code like controllers.
class Caretaker<T> {
  final _mementos = <Memento<T>>[];
  final Originator<T> _originator;
  final int mementoLimit;

  Caretaker(this._originator, this.mementoLimit);

  void makeSnapshot() {
    if (_mementos.length > mementoLimit) {
      _mementos
        ..removeAt(0)
        ..add(_originator.save());
    } else {
      _mementos.add(_originator.save());
    }
  }

  void undo() {
    if (_mementos.isNotEmpty) {
      _mementos.removeLast()..restore();
    }
  }
}
