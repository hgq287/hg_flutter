import 'package:hg_flutter/core/id/id.dart';
import 'package:hg_flutter/domain/intelligence/inference.dart';
import 'package:hg_flutter/domain/intelligence/on_device_ai.dart';
import 'package:hg_flutter/domain/intelligence/retriever.dart';
import 'package:hg_flutter/domain/intelligence/safety_gateway.dart';
import 'package:hg_flutter/domain/ledger/ledger_port.dart';
import 'package:hg_flutter/domain/money/money.dart';
import 'package:hg_flutter/features/assistant/domain/ai_action.dart';

final class AskGrounded {
  const AskGrounded({
    required SafetyGateway safety,
    required Retriever retriever,
    required OnDeviceAi onDeviceAi,
    required LedgerPort ledger,
  }) : _safety = safety,
       _retriever = retriever,
       _onDeviceAi = onDeviceAi,
       _ledger = ledger;

  final SafetyGateway _safety;
  final Retriever _retriever;
  final OnDeviceAi _onDeviceAi;
  final LedgerPort _ledger;

  static const _mutating = {
    AiIntent.transfer,
    AiIntent.mutateLimit,
    AiIntent.changePayee,
  };

  Future<AiAction> call(String question) async {
    final inbound = await _safety.inspectInbound(UserUtterance(question));
    final intent = inbound.intent ?? AiIntent.unknown;
    if (_mutating.contains(intent)) {
      return const NavigateToFlow('/home');
    }
    if (!inbound.allowed) {
      return Refuse(inbound.reason ?? 'Request blocked');
    }

    final facts = <String>[];
    if (intent == AiIntent.explainTxn || _asksForBalance(question)) {
      final balance = await _ledger.availableBalance('primary');
      facts.add('available_balance=${balance.toString()}');
      final txns = await _ledger.transactions(const TxnFilter(limit: 3));
      for (final txn in txns) {
        facts.add('txn:${txn.id}:${txn.description}:${txn.amount}');
      }
    }

    final chunks = await _retriever.retrieve(RetrievalQuery(text: question));
    final grounding = GroundingPack(
      facts: facts,
      chunks: chunks.map((chunk) => chunk.text).toList(),
    );

    final prompt = [
      'Answer only using these facts. Do not invent numbers.',
      grounding.joined,
      'Question: ${inbound.maskedText ?? question}',
    ].join('\n');

    final buffer = StringBuffer();
    await for (final event in _onDeviceAi.infer(
      InferenceRequest(
        id: newId(),
        modality: AiModality.text,
        inputs: [AiInput.text(prompt)],
      ),
    )) {
      buffer.write(event.text);
      if (event.done) {
        break;
      }
    }

    final draft = ModelDraft(buffer.toString());
    final outbound = await _safety.inspectOutbound(draft, grounding);
    if (!outbound.allowed) {
      return Refuse(outbound.reason ?? 'Response blocked');
    }

    return DisplayText(draft.text);
  }

  bool _asksForBalance(String question) {
    final lower = question.toLowerCase();
    return lower.contains('balance') || lower.contains('so du');
  }
}
