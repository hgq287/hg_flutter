import 'package:hg_native/src/models.dart';

class FakeHgNativeSecureStore implements HgNativeSecureStore {
  FakeHgNativeSecureStore([Map<String, String>? seed]) : _values = {...?seed};

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

class FakeHgNativeOnDeviceAi implements HgNativeOnDeviceAi {
  const FakeHgNativeOnDeviceAi();

  @override
  Future<NativeAiAvailability> availability() async {
    return const NativeAiAvailability(ready: true, backend: 'fake');
  }

  @override
  Future<void> load(NativeModelSpec spec) async {}

  @override
  Future<NativeInferenceEvent> infer(NativeInferenceRequest request) async {
    return NativeInferenceEvent(
      requestId: request.id,
      text: 'Native stub: ${request.prompt}',
      done: true,
    );
  }

  @override
  Future<void> cancel(String requestId) async {}

  @override
  Future<void> unload() async {}
}
