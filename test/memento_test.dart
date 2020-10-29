import 'package:memento/memento.dart';
import 'package:test/test.dart';

class MyOriginator implements Originator<int> {
  int counter = 0;

  void inc() => ++counter;

  @override
  Memento<int> save() => Memento(counter, this);

  @override
  void setState(int state) => counter = state;
}

void main() {
  group('Caretaker: ', () {
    test('must restore Originator state by undo call', () {
      final originator = MyOriginator();
      final caretaker = Caretaker(originator, 10);
      caretaker.makeSnapshot();
      originator..inc()..inc();
      caretaker.undo();

      expect(originator.counter, 0);
    });
  });
}
