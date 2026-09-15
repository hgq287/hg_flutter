import 'package:flutter/services.dart';
import 'package:hg_native/src/models.dart';

class MethodChannelOnDeviceAi implements HgNativeOnDeviceAi {
  MethodChannelOnDeviceAi(this._channel);

  final MethodChannel _channel;

  @override
  Future<NativeAiAvailability> availability() async {
    final data = await _channel.invokeMapMethod<String, Object?>(
      'onDeviceAi.availability',
    );
    return NativeAiAvailability(
      ready: data?['ready'] as bool? ?? false,
      backend: data?['backend'] as String? ?? 'unknown',
    );
  }

  @override
  Future<void> load(NativeModelSpec spec) {
    return _channel.invokeMethod<void>('onDeviceAi.load', {
      'id': spec.id,
      'source': spec.source,
      'preferredBackend': spec.preferredBackend,
    });
  }

  @override
  Future<NativeInferenceEvent> infer(NativeInferenceRequest request) async {
    final data = await _channel.invokeMapMethod<String, Object?>(
      'onDeviceAi.infer',
      {
        'id': request.id,
        'modality': request.modality,
        'prompt': request.prompt,
      },
    );
    return NativeInferenceEvent(
      requestId: data?['requestId'] as String? ?? request.id,
      text: data?['text'] as String? ?? '',
      done: data?['done'] as bool? ?? true,
    );
  }

  @override
  Future<void> cancel(String requestId) {
    return _channel.invokeMethod<void>('onDeviceAi.cancel', {
      'requestId': requestId,
    });
  }

  @override
  Future<void> unload() {
    return _channel.invokeMethod<void>('onDeviceAi.unload');
  }
}
