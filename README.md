# 💰 Family Budget

A cross-platform personal finance app built with Flutter — track your income, expenses, and budgets with full offline support.

## Features

- **Dashboard** — at-a-glance overview of income, expenses, and balance for the current month
- **Transactions** — add, edit, and delete income/expense entries with category tagging
- **Budgets** — set monthly spending limits per category and track progress
- **Categories** — create and manage your own custom categories (icon + color)
- **Multi-currency** — USD, EUR, MDL, UAH support
- **Multi-language** — English, Romanian, Russian
- **Dark & Light theme** — follows system preference with manual override
- **Offline-first** — all data stored locally on device; backend sync planned

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| State Management | Riverpod |
| Navigation | GoRouter |
| Local Storage | SharedPreferences |
| Charts | fl_chart |
| Fonts | Google Fonts (Inter) |
| Localization | Flutter Intl (ARB) |

## Getting Started

### Prerequisites
- Flutter SDK `^3.11.0`
- Dart SDK `^3.11.0`

### Run

```bash
flutter pub get
flutter run
```

### First Launch

The app starts empty — register a local account, then create your categories, budgets, and transactions.

## Project Structure

```
lib/
├── core/
│   ├── models/       # App-wide models (currency, etc.)
│   ├── providers/    # Locale & currency providers
│   ├── router/       # GoRouter configuration
│   ├── theme/        # Light & dark theme
│   └── utils/        # Currency formatter
├── data/
│   ├── local/        # LocalStorageService (SharedPreferences)
│   ├── models/       # Transaction, Category, Budget, User
│   └── repositories/ # Data access layer (swappable for remote)
├── features/
│   ├── auth/         # Login & registration
│   ├── budgets/      # Budget management
│   ├── categories/   # Category management
│   ├── dashboard/    # Home screen & spending chart
│   ├── settings/     # Theme, language, currency settings
│   └── transactions/ # Transaction list & add/edit form
└── l10n/             # Localization strings (EN, RO, RU)
```

## Roadmap

- [ ] Backend API integration (REST)
- [ ] Cloud sync across devices
- [ ] Recurring transactions
- [ ] Export to CSV/PDF
- [ ] Budget notifications
