final class RetrievalQuery {
  const RetrievalQuery({required this.text, this.limit = 4});
  final String text;
  final int limit;
}

final class Chunk {
  const Chunk({
    required this.id,
    required this.source,
    required this.text,
    required this.score,
    this.asOf,
    this.privilege = 'public',
  });

  final String id;
  final String source;
  final String text;
  final double score;
  final DateTime? asOf;
  final String privilege;
}

abstract class Retriever {
  Future<List<Chunk>> retrieve(RetrievalQuery query);
}
