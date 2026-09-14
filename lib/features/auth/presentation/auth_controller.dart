import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hg_flutter/app/di/providers.dart';

final class AuthUiState {
  const AuthUiState({this.loading = false, this.error});

  final bool loading;
  final String? error;
}

class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() => const AuthUiState();

  Future<bool> signIn({required String email, required String password}) async {
    state = const AuthUiState(loading: true);
    final result = await ref
        .read(signInUseCaseProvider)
        .call(email: email, password: password);
    return result.fold(
      (error) {
        state = AuthUiState(error: error.message);
        return false;
      },
      (_) {
        state = const AuthUiState();
        return true;
      },
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthUiState>(
  AuthController.new,
);
