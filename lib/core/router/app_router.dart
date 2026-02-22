import 'package:family_budget/features/auth/providers/auth_provider.dart';
import 'package:family_budget/features/auth/screens/login_screen.dart';
import 'package:family_budget/features/auth/screens/register_screen.dart';
import 'package:family_budget/features/budgets/screens/budget_screen.dart';
import 'package:family_budget/features/categories/screens/categories_screen.dart';
import 'package:family_budget/features/dashboard/screens/dashboard_screen.dart';
import 'package:family_budget/features/settings/screens/settings_screen.dart';
import 'package:family_budget/features/transactions/screens/add_edit_transaction_screen.dart';
import 'package:family_budget/features/transactions/screens/transactions_screen.dart';
import 'package:family_budget/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoading = authState.status == AuthStatus.loading ||
          authState.status == AuthStatus.initial;
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (isLoading) return null;

      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/transactions',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TransactionsScreen(),
            ),
          ),
          GoRoute(
            path: '/budgets',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BudgetScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/transaction/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddEditTransactionScreen(),
      ),
      GoRoute(
        path: '/transaction/edit/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return AddEditTransactionScreen(
            transactionId: state.pathParameters['id'],
          );
        },
      ),
      GoRoute(
        path: '/categories',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CategoriesScreen(),
      ),
    ],
  );
});
