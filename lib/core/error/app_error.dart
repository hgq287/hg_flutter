sealed class AppError {
  const AppError(this.message);
  final String message;
}

final class NetworkError extends AppError {
  const NetworkError(super.message, {this.statusCode});
  final int? statusCode;
}

final class AuthError extends AppError {
  const AuthError(super.message);
}

final class ValidationError extends AppError {
  const ValidationError(super.message);
}

final class SafetyError extends AppError {
  const SafetyError(super.message);
}

final class NativeError extends AppError {
  const NativeError(super.message);
}

final class UnexpectedError extends AppError {
  const UnexpectedError(super.message);
}
