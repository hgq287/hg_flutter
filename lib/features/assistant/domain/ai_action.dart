sealed class AiAction {
  const AiAction();
}

final class DisplayText extends AiAction {
  const DisplayText(this.text);
  final String text;
}

final class NavigateToFlow extends AiAction {
  const NavigateToFlow(this.route);
  final String route;
}

final class Refuse extends AiAction {
  const Refuse(this.reason);
  final String reason;
}
