import 'package:hg_flutter/core/error/app_error.dart';

final class Result<T> {
  const Result._({T? value, AppError? error}) : _value = value, _error = error;

  factory Result.ok(T value) => Result._(value: value);
  factory Result.err(AppError error) => Result._(error: error);

  final T? _value;
  final AppError? _error;

  bool get isSuccess => _error == null;
  bool get isError => _error != null;

  T get value => _value as T;
  AppError get error => _error!;

  R fold<R>(R Function(AppError error) onError, R Function(T value) onSuccess) {
    if (_error != null) {
      return onError(_error);
    }
    return onSuccess(_value as T);
  }
}
