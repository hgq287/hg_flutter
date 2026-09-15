class NativeModelSpec {
  const NativeModelSpec({
    required this.id,
    required this.source,
    this.preferredBackend,
  });

  final String id;
  final String source;
  final String? preferredBackend;
}

class NativeInferenceRequest {
  const NativeInferenceRequest({
    required this.id,
    required this.modality,
    required this.prompt,
  });

  final String id;
  final String modality;
  final String prompt;
}

class NativeInferenceEvent {
  const NativeInferenceEvent({
    required this.requestId,
    required this.text,
    required this.done,
  });

  final String requestId;
  final String text;
  final bool done;
}

class NativeAiAvailability {
  const NativeAiAvailability({required this.ready, required this.backend});

  final bool ready;
  final String backend;
}

abstract class HgNativeSecureStore {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

abstract class HgNativeOnDeviceAi {
  Future<NativeAiAvailability> availability();
  Future<void> load(NativeModelSpec spec);
  Future<NativeInferenceEvent> infer(NativeInferenceRequest request);
  Future<void> cancel(String requestId);
  Future<void> unload();
}
