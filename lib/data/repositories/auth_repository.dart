import 'package:family_budget/data/mock/mock_auth_service.dart';
import 'package:family_budget/data/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final MockAuthService _authService = MockAuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(
      email: email,
      password: password,
    );

    await _saveTokens(result.tokens);
    await _saveUser(result.user);
    return result.user;
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
    );

    await _saveTokens(result.tokens);
    await _saveUser(result.user);
    return result.user;
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;

      final tokens = await _authService.refreshTokens(refreshToken);
      await _saveTokens(tokens);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessTokenKey);
    if (token == null) return false;

    if (!_authService.validateAccessToken(token)) {
      return refreshToken();
    }
    return true;
  }

  Future<User?> getCurrentUser() async {
    final id = await _storage.read(key: _userIdKey);
    final name = await _storage.read(key: _userNameKey);
    final email = await _storage.read(key: _userEmailKey);

    if (id == null || name == null || email == null) return null;

    return User(id: id, name: name, email: email);
  }

  Future<void> logout() async {
    final token = await _storage.read(key: _accessTokenKey);
    if (token != null) {
      _authService.logout(token);
    }
    await _storage.deleteAll();
  }

  Future<void> _saveTokens(AuthTokens tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  Future<void> _saveUser(User user) async {
    await _storage.write(key: _userIdKey, value: user.id);
    await _storage.write(key: _userNameKey, value: user.name);
    await _storage.write(key: _userEmailKey, value: user.email);
  }
}
