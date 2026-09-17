enum AiIntent {
  faq,
  explainTxn,
  search,
  transfer,
  mutateLimit,
  changePayee,
  unknown,
}

final class UserUtterance {
  const UserUtterance(this.text);
  final String text;
}

final class GroundingPack {
  const GroundingPack({required this.facts, required this.chunks});
  final List<String> facts;
  final List<String> chunks;

  String get joined => [...facts, ...chunks].join('\n');
}

final class ModelDraft {
  const ModelDraft(this.text);
  final String text;
}

final class SafetyDecision {
  const SafetyDecision.allow({this.intent, this.maskedText})
    : allowed = true,
      reason = null;

  const SafetyDecision.deny(this.reason, {this.intent, this.maskedText})
    : allowed = false;

  final bool allowed;
  final String? reason;
  final AiIntent? intent;
  final String? maskedText;
}

abstract class SafetyGateway {
  Future<SafetyDecision> inspectInbound(UserUtterance utterance);
  Future<SafetyDecision> inspectOutbound(
    ModelDraft draft,
    GroundingPack grounding,
  );
}
