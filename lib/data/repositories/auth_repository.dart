import 'package:family_budget/data/models/user.dart';
import 'package:family_budget/data/remote/api_service.dart';

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/api/auth/login',
      body: {'email': email, 'password': password},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    await _api.saveToken(data['token'] as String);
    return User(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
    );
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/api/auth/register',
      body: {'name': name, 'email': email, 'password': password},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    await _api.saveToken(data['token'] as String);
    return User(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
    );
  }

  Future<bool> isLoggedIn() => _api.hasToken();

  /// The token alone is sufficient to know we're logged in.
  /// We return a minimal User from whatever we have stored.
  /// The full profile is fetched per-screen as needed.
  Future<User?> getCurrentUser() async {
    if (!await _api.hasToken()) return null;
    // We don't have a /me endpoint yet — return null to trigger re-login
    return null;
  }

  Future<void> logout() async {
    await _api.clearToken();
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
