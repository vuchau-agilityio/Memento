A pratical implementation of Memento design pattern.
Useful for restore internal state of objects.

## Usage

A simple usage example:

```dart
import 'dart:async';

import 'package:memento/memento.dart';

class UserConfig {
  final String image;
  final String nick;

  UserConfig(this.image, this.nick);

  UserConfig copyWith({
    String image,
    String nick,
  }) {
    return UserConfig(
      image ?? this.image,
      nick ?? this.nick,
    );
  }
}

class ProfileViewModel implements Originator<UserConfig> {
  var user = UserConfig('your_image.png', 'bob');
  final _controller = StreamController<UserConfig>();
  Sink<UserConfig> get userConfigEvent => _controller.sink;
  Stream<UserConfig> get userConfigStream => _controller.stream;

  @override
  Memento<UserConfig> save() => Memento(user.copyWith(), this);

  @override
  void setState(UserConfig state) {
    user = state;
    userConfigEvent.add(user);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  final originator = ProfileViewModel();
  final caretaker = Caretaker(originator, 10);
  caretaker.makeSnapshot();
  originator.user = originator.user.copyWith(nick: 'john');
  caretaker.undo();
  originator.dispose();
}

```

### How to install?

Add `memento: 1.0.1` on your pubspec.yaml
