import 'dart:async';

import 'package:hg_flutter/domain/session/session.dart';
import 'package:hg_flutter/domain/session/session_port.dart';

final class InMemorySessionPort implements SessionPort {
  InMemorySessionPort({Session? initial}) : _current = initial;

  Session? _current;
  final _controller = StreamController<Session?>.broadcast();

  @override
  Session? current() => _current;

  @override
  Stream<Session?> watch() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<void> set(Session session) async {
    _current = session;
    _controller.add(_current);
  }

  @override
  Future<void> clear() async {
    _current = null;
    _controller.add(null);
  }
}
