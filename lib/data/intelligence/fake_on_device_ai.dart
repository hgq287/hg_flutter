import 'package:hg_flutter/domain/intelligence/inference.dart';
import 'package:hg_flutter/domain/intelligence/model_spec.dart';
import 'package:hg_flutter/domain/intelligence/on_device_ai.dart';

final class FakeOnDeviceAi implements OnDeviceAi {
  const FakeOnDeviceAi();

  @override
  Future<AiAvailability> availability() async {
    return const AiAvailability(ready: true, backend: 'fake');
  }

  @override
  Future<void> load(ModelSpec spec) async {}

  @override
  Stream<InferenceEvent> infer(InferenceRequest request) async* {
    yield InferenceEvent(
      requestId: request.id,
      text:
          'Grounded stub answer using the provided facts. '
          'Question understood: ${request.prompt.split('Question:').last.trim()}',
      done: true,
    );
  }

  @override
  Future<void> cancel(String requestId) async {}

  @override
  Future<void> unload() async {}
}
