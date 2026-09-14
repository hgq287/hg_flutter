final class Session {
  const Session({
    required this.userId,
    required this.email,
    required this.accessToken,
    this.refreshToken,
  });

  final String userId;
  final String email;
  final String accessToken;
  final String? refreshToken;
}
