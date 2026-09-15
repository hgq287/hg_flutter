import 'package:hg_flutter/domain/intelligence/inference.dart';
import 'package:hg_flutter/domain/intelligence/model_spec.dart';
import 'package:hg_flutter/domain/intelligence/on_device_ai.dart';
import 'package:hg_native/hg_native.dart';

final class PluginOnDeviceAi implements OnDeviceAi {
  PluginOnDeviceAi({HgNativeOnDeviceAi? engine})
    : _engine = engine ?? HgNative.onDeviceAi;

  final HgNativeOnDeviceAi _engine;

  @override
  Future<AiAvailability> availability() async {
    final dto = await _engine.availability();
    return AiAvailability(ready: dto.ready, backend: dto.backend);
  }

  @override
  Future<void> load(ModelSpec spec) {
    return _engine.load(
      NativeModelSpec(
        id: spec.id,
        source: spec.source.name,
        preferredBackend: spec.preferredBackend?.name,
      ),
    );
  }

  @override
  Stream<InferenceEvent> infer(InferenceRequest request) async* {
    final event = await _engine.infer(
      NativeInferenceRequest(
        id: request.id,
        modality: request.modality.name,
        prompt: request.prompt,
      ),
    );
    yield InferenceEvent(
      requestId: event.requestId,
      text: event.text,
      done: event.done,
    );
  }

  @override
  Future<void> cancel(String requestId) => _engine.cancel(requestId);

  @override
  Future<void> unload() => _engine.unload();
}
