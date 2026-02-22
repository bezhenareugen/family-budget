import 'package:family_budget/app.dart';
import 'package:family_budget/data/remote/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global provider for ApiService — singleton, injected at startup.
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    ProviderScope(
      child: App(onAppReady: FlutterNativeSplash.remove),
    ),
  );
}
