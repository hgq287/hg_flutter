import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hg_flutter/app/di/providers.dart';
import 'package:hg_flutter/features/assistant/domain/ai_action.dart';

final class AssistantUiState {
  const AssistantUiState({this.loading = false, this.message, this.route});

  final bool loading;
  final String? message;
  final String? route;
}

class AssistantController extends Notifier<AssistantUiState> {
  @override
  AssistantUiState build() => const AssistantUiState();

  Future<void> ask(String question) async {
    state = const AssistantUiState(loading: true);
    final action = await ref.read(askGroundedProvider).call(question);
    switch (action) {
      case DisplayText(:final text):
        state = AssistantUiState(message: text);
      case Refuse(:final reason):
        state = AssistantUiState(message: reason);
      case NavigateToFlow(:final route):
        state = AssistantUiState(
          message: 'This action continues in a signed flow.',
          route: route,
        );
    }
  }
}

final assistantControllerProvider =
    NotifierProvider<AssistantController, AssistantUiState>(
      AssistantController.new,
    );
