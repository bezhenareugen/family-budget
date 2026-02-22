import 'dart:convert';
import 'package:family_budget/core/constants/app_constants.dart';
import 'package:family_budget/data/mock/mock_data.dart';
import 'package:family_budget/data/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
}

class MockAuthService {
  static final MockAuthService _instance = MockAuthService._();
  factory MockAuthService() => _instance;
  MockAuthService._();

  final _uuid = const Uuid();
  final Map<String, AuthTokens> _activeTokens = {};
  final Map<String, String> _refreshToUser = {};

  Future<({AuthTokens tokens, User user})> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(AppConstants.apiDelay);

    final storedPassword = MockData.userPasswords[email.toLowerCase()];
    if (storedPassword == null || storedPassword != password) {
      throw AuthException('Invalid email or password');
    }

    final user = MockData.users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    final tokens = _generateTokens(user.id);
    return (tokens: tokens, user: user);
  }

  Future<({AuthTokens tokens, User user})> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(AppConstants.apiDelay);

    if (MockData.userPasswords.containsKey(email.toLowerCase())) {
      throw AuthException('Email already registered');
    }

    final user = User(
      id: _uuid.v4(),
      name: name,
      email: email.toLowerCase(),
    );

    // Add to mock data
    MockData.users.add(user);
    MockData.userPasswords[email.toLowerCase()] = password;

    final tokens = _generateTokens(user.id);
    return (tokens: tokens, user: user);
  }

  Future<AuthTokens> refreshTokens(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final userId = _refreshToUser[refreshToken];
    if (userId == null) {
      throw AuthException('Invalid refresh token');
    }

    // Invalidate old refresh token
    _refreshToUser.remove(refreshToken);

    return _generateTokens(userId);
  }

  bool validateAccessToken(String accessToken) {
    final tokens = _activeTokens[accessToken];
    if (tokens == null) return false;
    return DateTime.now().isBefore(tokens.expiresAt);
  }

  String? getUserIdFromToken(String accessToken) {
    try {
      final parts = accessToken.split('.');
      if (parts.length != 3) return null;
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload['sub'] as String?;
    } catch (_) {
      return null;
    }
  }

  void logout(String accessToken) {
    _activeTokens.remove(accessToken);
  }

  AuthTokens _generateTokens(String userId) {
    final now = DateTime.now();
    final expiresAt = now.add(AppConstants.accessTokenExpiry);

    // Build a fake JWT (header.payload.signature)
    final header = base64Url.encode(utf8.encode(json.encode({
      'alg': 'HS256',
      'typ': 'JWT',
    })));

    final payload = base64Url.encode(utf8.encode(json.encode({
      'sub': userId,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
    })));

    final signature = base64Url.encode(utf8.encode('mock-signature-${_uuid.v4()}'));

    final accessToken = '$header.$payload.$signature';
    final refreshToken = _uuid.v4();

    final tokens = AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );

    _activeTokens[accessToken] = tokens;
    _refreshToUser[refreshToken] = userId;

    return tokens;
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
