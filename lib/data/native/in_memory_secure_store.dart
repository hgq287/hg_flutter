import 'package:hg_flutter/domain/secure_store/secure_store.dart';

final class InMemorySecureStore implements SecureStore {
  InMemorySecureStore([Map<String, String>? seed]) : _values = {...?seed};

  final Map<String, String> _values;

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }
}
