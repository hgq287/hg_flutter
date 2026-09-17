import 'package:hg_flutter/domain/intelligence/safety_gateway.dart';

final class SafetyGatewayImpl implements SafetyGateway {
  const SafetyGatewayImpl({this.maxLength = 2000});

  final int maxLength;

  static final _card = RegExp(r'\b(?:\d[ -]*?){13,19}\b');
  static final _cvv = RegExp(r'\b\d{3,4}\b');
  static final _transfer = RegExp(
    r'\b(transfer|wire|send money|payee|beneficiary|chuyen tien)\b',
    caseSensitive: false,
  );
  static final _limit = RegExp(
    r'\b(raise limit|override limit|increase limit)\b',
    caseSensitive: false,
  );
  static final _payee = RegExp(
    r'\b(add payee|change beneficiary|new beneficiary)\b',
    caseSensitive: false,
  );
  static final _explain = RegExp(
    r'\b(transaction|txn|receipt|charge|giao dich)\b',
    caseSensitive: false,
  );
  static final _inventedReturn = RegExp(
    r'\b(guaranteed return|guaranteed apr|risk[- ]free)\b',
    caseSensitive: false,
  );

  @override
  Future<SafetyDecision> inspectInbound(UserUtterance utterance) async {
    final text = utterance.text.trim();
    if (text.isEmpty) {
      return const SafetyDecision.deny('Empty prompt');
    }
    if (text.length > maxLength) {
      return const SafetyDecision.deny('Prompt exceeds length limit');
    }
    if (_looksLikeJailbreak(text)) {
      return const SafetyDecision.deny('Prompt injection blocked');
    }

    final masked = text.replaceAll(_card, '[PAN]');
    final intent = _intentFor(text);
    if (_isMutating(intent)) {
      return SafetyDecision.deny(
        'This action must use the signed payment flow',
        intent: intent,
        maskedText: masked,
      );
    }
    return SafetyDecision.allow(intent: intent, maskedText: masked);
  }

  @override
  Future<SafetyDecision> inspectOutbound(
    ModelDraft draft,
    GroundingPack grounding,
  ) async {
    if (draft.text.trim().isEmpty) {
      return const SafetyDecision.deny('Empty model output');
    }
    if (_inventedReturn.hasMatch(draft.text)) {
      return const SafetyDecision.deny('Unsupported financial claim');
    }
    if (!_numbersAreGrounded(draft.text, grounding)) {
      return const SafetyDecision.deny('Numbers are not in the grounding pack');
    }
    return const SafetyDecision.allow();
  }

  AiIntent _intentFor(String text) {
    if (_payee.hasMatch(text)) {
      return AiIntent.changePayee;
    }
    if (_limit.hasMatch(text)) {
      return AiIntent.mutateLimit;
    }
    if (_transfer.hasMatch(text)) {
      return AiIntent.transfer;
    }
    if (_explain.hasMatch(text)) {
      return AiIntent.explainTxn;
    }
    if (text.toLowerCase().contains('search') ||
        text.toLowerCase().contains('find')) {
      return AiIntent.search;
    }
    return AiIntent.faq;
  }

  bool _isMutating(AiIntent intent) {
    return intent == AiIntent.transfer ||
        intent == AiIntent.mutateLimit ||
        intent == AiIntent.changePayee;
  }

  bool _looksLikeJailbreak(String text) {
    final lower = text.toLowerCase();
    return lower.contains('ignore previous') ||
        lower.contains('ignore all instructions') ||
        lower.contains('system prompt');
  }

  bool _numbersAreGrounded(String draft, GroundingPack grounding) {
    final numbers = RegExp(r'\d+(?:\.\d+)?')
        .allMatches(draft)
        .map((match) => match.group(0)!)
        .where((value) => value.length >= 2)
        .where((value) => !_cvv.hasMatch(value) || value.length > 4);
    final pack = grounding.joined;
    for (final number in numbers) {
      if (!pack.contains(number)) {
        return false;
      }
    }
    return true;
  }
}
