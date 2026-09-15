import 'package:hg_flutter/core/error/app_error.dart';
import 'package:hg_flutter/domain/secure_store/secure_store.dart';
import 'package:hg_native/hg_native.dart';

final class PluginSecureStore implements SecureStore {
  PluginSecureStore({HgNativeSecureStore? store})
    : _store = store ?? HgNative.secureStore;

  final HgNativeSecureStore _store;

  @override
  Future<void> write(String key, String value) async {
    try {
      await _store.write(key, value);
    } catch (error) {
      throw NativeError('SecureStore write failed: $error');
    }
  }

  @override
  Future<String?> read(String key) async {
    try {
      return await _store.read(key);
    } catch (error) {
      throw NativeError('SecureStore read failed: $error');
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _store.delete(key);
    } catch (error) {
      throw NativeError('SecureStore delete failed: $error');
    }
  }
}
