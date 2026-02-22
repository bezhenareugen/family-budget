import 'package:flutter/material.dart';
import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:family_budget/data/models/budget.dart';
import 'package:family_budget/data/models/user.dart';

class MockData {
  MockData._();

  static final List<User> users = [
    const User(
      id: 'user-1',
      name: 'John Doe',
      email: 'user@family.com',
    ),
    const User(
      id: 'user-2',
      name: 'Jane Doe',
      email: 'jane@family.com',
    ),
  ];

  // password: password123 for all users
  static final Map<String, String> userPasswords = {
    'user@family.com': 'password123',
    'jane@family.com': 'password123',
  };

  static final List<Category> categories = [
    Category(
      id: 'cat-1',
      name: 'Food & Dining',
      icon: Icons.restaurant,
      color: Colors.orange.shade600,
    ),
    Category(
      id: 'cat-2',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Colors.blue.shade600,
    ),
    Category(
      id: 'cat-3',
      name: 'Housing',
      icon: Icons.home,
      color: Colors.purple.shade600,
    ),
    Category(
      id: 'cat-4',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Colors.pink.shade600,
    ),
    Category(
      id: 'cat-5',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.teal.shade600,
    ),
    Category(
      id: 'cat-6',
      name: 'Health',
      icon: Icons.local_hospital,
      color: Colors.red.shade600,
    ),
    Category(
      id: 'cat-7',
      name: 'Education',
      icon: Icons.school,
      color: Colors.indigo.shade600,
    ),
    Category(
      id: 'cat-8',
      name: 'Salary',
      icon: Icons.account_balance_wallet,
      color: Colors.green.shade600,
    ),
  ];

  static List<Transaction> get transactions {
    final now = DateTime.now();
    return [
      Transaction(
        id: 'txn-1',
        amount: 5500.00,
        type: TransactionType.income,
        categoryId: 'cat-8',
        description: 'Monthly Salary',
        date: DateTime(now.year, now.month, 1),
        createdAt: DateTime(now.year, now.month, 1),
      ),
      Transaction(
        id: 'txn-2',
        amount: 1200.00,
        type: TransactionType.expense,
        categoryId: 'cat-3',
        description: 'Rent Payment',
        date: DateTime(now.year, now.month, 2),
        createdAt: DateTime(now.year, now.month, 2),
      ),
      Transaction(
        id: 'txn-3',
        amount: 85.50,
        type: TransactionType.expense,
        categoryId: 'cat-1',
        description: 'Grocery Shopping',
        date: DateTime(now.year, now.month, 3),
        createdAt: DateTime(now.year, now.month, 3),
      ),
      Transaction(
        id: 'txn-4',
        amount: 45.00,
        type: TransactionType.expense,
        categoryId: 'cat-2',
        description: 'Gas Station',
        date: DateTime(now.year, now.month, 4),
        createdAt: DateTime(now.year, now.month, 4),
      ),
      Transaction(
        id: 'txn-5',
        amount: 120.00,
        type: TransactionType.expense,
        categoryId: 'cat-4',
        description: 'Concert Tickets',
        date: DateTime(now.year, now.month, 5),
        createdAt: DateTime(now.year, now.month, 5),
      ),
      Transaction(
        id: 'txn-6',
        amount: 250.00,
        type: TransactionType.expense,
        categoryId: 'cat-5',
        description: 'New Shoes & Jacket',
        date: DateTime(now.year, now.month, 6),
        createdAt: DateTime(now.year, now.month, 6),
      ),
      Transaction(
        id: 'txn-7',
        amount: 65.00,
        type: TransactionType.expense,
        categoryId: 'cat-6',
        description: 'Doctor Visit',
        date: DateTime(now.year, now.month, 7),
        createdAt: DateTime(now.year, now.month, 7),
      ),
      Transaction(
        id: 'txn-8',
        amount: 150.00,
        type: TransactionType.expense,
        categoryId: 'cat-1',
        description: 'Restaurant Dinner',
        date: DateTime(now.year, now.month, 8),
        createdAt: DateTime(now.year, now.month, 8),
      ),
      Transaction(
        id: 'txn-9',
        amount: 35.00,
        type: TransactionType.expense,
        categoryId: 'cat-2',
        description: 'Uber Rides',
        date: DateTime(now.year, now.month, 9),
        createdAt: DateTime(now.year, now.month, 9),
      ),
      Transaction(
        id: 'txn-10',
        amount: 500.00,
        type: TransactionType.income,
        categoryId: 'cat-8',
        description: 'Freelance Work',
        date: DateTime(now.year, now.month, 10),
        createdAt: DateTime(now.year, now.month, 10),
      ),
      Transaction(
        id: 'txn-11',
        amount: 200.00,
        type: TransactionType.expense,
        categoryId: 'cat-7',
        description: 'Online Course',
        date: DateTime(now.year, now.month, 11),
        createdAt: DateTime(now.year, now.month, 11),
      ),
      Transaction(
        id: 'txn-12',
        amount: 95.00,
        type: TransactionType.expense,
        categoryId: 'cat-1',
        description: 'Grocery Shopping',
        date: DateTime(now.year, now.month, 12),
        createdAt: DateTime(now.year, now.month, 12),
      ),
      Transaction(
        id: 'txn-13',
        amount: 60.00,
        type: TransactionType.expense,
        categoryId: 'cat-4',
        description: 'Streaming Subscriptions',
        date: DateTime(now.year, now.month, 13),
        createdAt: DateTime(now.year, now.month, 13),
      ),
      Transaction(
        id: 'txn-14',
        amount: 180.00,
        type: TransactionType.expense,
        categoryId: 'cat-5',
        description: 'Electronics',
        date: DateTime(now.year, now.month, 14),
        createdAt: DateTime(now.year, now.month, 14),
      ),
      Transaction(
        id: 'txn-15',
        amount: 40.00,
        type: TransactionType.expense,
        categoryId: 'cat-6',
        description: 'Pharmacy',
        date: DateTime(now.year, now.month, 15),
        createdAt: DateTime(now.year, now.month, 15),
      ),
    ];
  }

  static List<Budget> get budgets {
    final now = DateTime.now();
    return [
      Budget(
        id: 'bud-1',
        categoryId: 'cat-1',
        limit: 500.00,
        spent: 330.50,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'bud-2',
        categoryId: 'cat-2',
        limit: 200.00,
        spent: 80.00,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'bud-3',
        categoryId: 'cat-3',
        limit: 1300.00,
        spent: 1200.00,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'bud-4',
        categoryId: 'cat-4',
        limit: 200.00,
        spent: 180.00,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'bud-5',
        categoryId: 'cat-5',
        limit: 400.00,
        spent: 430.00,
        month: now.month,
        year: now.year,
      ),
      Budget(
        id: 'bud-6',
        categoryId: 'cat-6',
        limit: 150.00,
        spent: 105.00,
        month: now.month,
        year: now.year,
      ),
    ];
  }
}
