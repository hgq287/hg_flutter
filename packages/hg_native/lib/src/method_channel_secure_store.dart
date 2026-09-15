import 'package:flutter/services.dart';
import 'package:hg_native/src/models.dart';

class MethodChannelSecureStore implements HgNativeSecureStore {
  MethodChannelSecureStore(this._channel);

  final MethodChannel _channel;

  @override
  Future<void> write(String key, String value) {
    return _channel.invokeMethod<void>('secureStore.write', {
      'key': key,
      'value': value,
    });
  }

  @override
  Future<String?> read(String key) {
    return _channel.invokeMethod<String>('secureStore.read', {'key': key});
  }

  @override
  Future<void> delete(String key) {
    return _channel.invokeMethod<void>('secureStore.delete', {'key': key});
  }
}
