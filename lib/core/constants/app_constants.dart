class AppConstants {
  AppConstants._();

  static const String appName = 'Family Budget';
  static const String appVersion = '1.0.0';

  // Mock API delay
  static const Duration apiDelay = Duration(milliseconds: 500);

  // Token expiry
  static const Duration accessTokenExpiry = Duration(minutes: 15);
  static const Duration refreshTokenExpiry = Duration(days: 7);
}
