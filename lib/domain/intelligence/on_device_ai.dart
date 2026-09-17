import 'package:hg_flutter/domain/intelligence/inference.dart';
import 'package:hg_flutter/domain/intelligence/model_spec.dart';

abstract class OnDeviceAi {
  Future<AiAvailability> availability();
  Future<void> load(ModelSpec spec);
  Stream<InferenceEvent> infer(InferenceRequest request);
  Future<void> cancel(String requestId);
  Future<void> unload();
}
