# hg_native

Federated plugin for `SecureStore` and `OnDeviceAi`.

The Pigeon IDL in `pigeons/native_api.dart` is the contract. v1 uses a single MethodChannel that matches those methods. iOS implements Keychain + a Core ML stub. Android implements private prefs + a LiteRT stub. Desktop and tests use the Dart fakes.

```bash
dart run pigeon --input pigeons/native_api.dart
flutter test
```
