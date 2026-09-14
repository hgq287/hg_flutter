abstract class SecureStore {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

const String kSessionEmailKey = 'session.email';
const String kSessionUserIdKey = 'session.userId';
const String kSessionAccessTokenKey = 'session.accessToken';
const String kSessionRefreshTokenKey = 'session.refreshToken';
