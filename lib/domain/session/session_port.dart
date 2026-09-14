import 'package:hg_flutter/domain/session/session.dart';

abstract class SessionPort {
  Session? current();
  Stream<Session?> watch();
  Future<void> set(Session session);
  Future<void> clear();
}
