import 'package:hg_flutter/domain/intelligence/retriever.dart';

final class InMemoryRetriever implements Retriever {
  InMemoryRetriever({List<Chunk>? chunks})
    : _chunks =
          chunks ??
          const [
            Chunk(
              id: 'help-fees',
              source: 'help',
              text:
                  'Incoming transfers are free. Outgoing domestic transfers '
                  'use the fee schedule published in-app. The model cannot quote a rate.',
              score: 1,
            ),
            Chunk(
              id: 'help-safety',
              source: 'policy',
              text:
                  'The assistant may explain transactions and help articles. '
                  'It cannot send money, change payees, or raise limits.',
              score: 1,
            ),
            Chunk(
              id: 'help-balance',
              source: 'help',
              text:
                  'Available balance is provided by the ledger, never invented '
                  'by the model.',
              score: 1,
            ),
          ];

  final List<Chunk> _chunks;

  @override
  Future<List<Chunk>> retrieve(RetrievalQuery query) async {
    final terms = query.text.toLowerCase().split(RegExp(r'\s+'));
    final scored = _chunks.map((chunk) {
      final hay = chunk.text.toLowerCase();
      final hits = terms.where((term) => term.isNotEmpty && hay.contains(term));
      return Chunk(
        id: chunk.id,
        source: chunk.source,
        text: chunk.text,
        score: hits.length.toDouble(),
        asOf: chunk.asOf,
        privilege: chunk.privilege,
      );
    }).toList()..sort((a, b) => b.score.compareTo(a.score));
    return scored.take(query.limit).toList();
  }
}
