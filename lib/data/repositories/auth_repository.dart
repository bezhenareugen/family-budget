import 'package:family_budget/data/local/local_storage_service.dart';
import 'package:family_budget/data/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  final LocalStorageService _storage;
  static const _uuid = Uuid();

  AuthRepository(this._storage);

  Future<User> login({
    required String email,
    required String password,
  }) async {
    // In local-only mode, check if user profile exists with matching email
    final profile = _storage.getUserProfile();
    if (profile != null) {
      final user = User.fromJson(profile);
      if (user.email.toLowerCase() == email.toLowerCase()) {
        return user;
      }
    }
    throw AuthException('Invalid email or password');
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Check if a user already exists
    final existing = _storage.getUserProfile();
    if (existing != null) {
      final existingUser = User.fromJson(existing);
      if (existingUser.email.toLowerCase() == email.toLowerCase()) {
        throw AuthException('Email already registered');
      }
    }

    final user = User(
      id: _uuid.v4(),
      name: name,
      email: email.toLowerCase(),
    );

    await _storage.saveUserProfile(user.toJson());
    return user;
  }

  Future<bool> isLoggedIn() async {
    return _storage.getUserProfile() != null;
  }

  Future<User?> getCurrentUser() async {
    final profile = _storage.getUserProfile();
    if (profile == null) return null;
    return User.fromJson(profile);
  }

  Future<void> logout() async {
    await _storage.clearUserProfile();
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
