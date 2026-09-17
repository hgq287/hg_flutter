enum ModelSource { asset, downloaded, system }

enum AiBackend { coreml, litert, foundation, geminiNano, fake }

final class ModelSpec {
  const ModelSpec({
    required this.id,
    required this.source,
    this.preferredBackend,
  });

  final String id;
  final ModelSource source;
  final AiBackend? preferredBackend;
}
