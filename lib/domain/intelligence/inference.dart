enum AiModality { text, image, audio, multimodal }

final class AiInput {
  const AiInput.text(this.text);
  final String text;
}

final class InferenceOptions {
  const InferenceOptions({this.maxTokens = 256});
  final int maxTokens;
}

final class InferenceRequest {
  const InferenceRequest({
    required this.id,
    required this.modality,
    required this.inputs,
    this.options = const InferenceOptions(),
  });

  final String id;
  final AiModality modality;
  final List<AiInput> inputs;
  final InferenceOptions options;

  String get prompt => inputs.map((input) => input.text).join('\n');
}

final class InferenceEvent {
  const InferenceEvent({
    required this.requestId,
    required this.text,
    required this.done,
  });

  final String requestId;
  final String text;
  final bool done;
}

final class AiAvailability {
  const AiAvailability({required this.ready, required this.backend});
  final bool ready;
  final String backend;
}
