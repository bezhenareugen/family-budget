# 💰 Family Budget

A cross-platform personal finance app built with Flutter + .NET — track your income, expenses, and budgets with full offline support and cloud sync.

## Monorepo Structure

```
budget-app/
├── lib/         ← Flutter client (mobile, web, desktop)
├── server/      ← .NET 10 API (EF Core + PostgreSQL)
└── README.md
```

## Features

- **Dashboard** — at-a-glance overview of income, expenses, and balance
- **Transactions** — add, edit, and delete income/expense entries with category tagging
- **Budgets** — set monthly spending limits per category and track progress
- **Categories** — create and manage custom categories (icon + color)
- **Multi-currency** — USD, EUR, MDL, UAH support
- **Multi-language** — English, Romanian, Russian
- **Dark & Light theme** — follows system preference with manual override
- **Offline-first** — all data stored locally on device; syncs when backend is connected

## Tech Stack

### Client (Flutter)

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| State Management | Riverpod |
| Navigation | GoRouter |
| Local Storage | SharedPreferences |
| Charts | fl_chart |
| Fonts | Google Fonts (Inter) |
| Localization | Flutter Intl (ARB) |

### Server (.NET)

| Layer | Technology |
|-------|-----------|
| Framework | .NET 10 Minimal API |
| ORM | Entity Framework Core |
| Database | PostgreSQL (Npgsql) |
| Auth | JWT Bearer |
| Password Hashing | BCrypt |

## Getting Started

### Prerequisites
- Flutter SDK `^3.11.0`
- .NET SDK `^10.0`
- PostgreSQL (or Docker)

### Client

```bash
flutter pub get
flutter run
```

### Server

```bash
cd server/FamilyBudget.Api
dotnet run
```

The API runs on `http://localhost:5000` by default with Swagger at `/openapi/v1.json`.

### Docker (Server)

```bash
cd server/FamilyBudget.Api
docker build -t family-budget-api .
docker run -p 8080:8080 \
  -e ConnectionStrings__DefaultConnection="Host=host.docker.internal;Port=5432;Database=family_budget;Username=postgres;Password=postgres" \
  family-budget-api
```

## API Endpoints

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/api/auth/register` | No | Register new user |
| POST | `/api/auth/login` | No | Login, returns JWT |
| GET | `/api/categories` | Yes | List user categories |
| POST | `/api/categories` | Yes | Create category |
| PUT | `/api/categories/{id}` | Yes | Update category |
| DELETE | `/api/categories/{id}` | Yes | Delete category |
| GET | `/api/transactions` | Yes | List transactions (filter: startDate, endDate, categoryId) |
| POST | `/api/transactions` | Yes | Create transaction |
| PUT | `/api/transactions/{id}` | Yes | Update transaction |
| DELETE | `/api/transactions/{id}` | Yes | Delete transaction |
| GET | `/api/budgets` | Yes | List budgets (filter: month, year) |
| POST | `/api/budgets` | Yes | Create budget |
| PUT | `/api/budgets/{id}` | Yes | Update budget |
| DELETE | `/api/budgets/{id}` | Yes | Delete budget |

## Project Structure

```
lib/                           (Flutter)
├── core/
│   ├── models/                # App-wide models (currency, etc.)
│   ├── providers/             # Locale & currency providers
│   ├── router/                # GoRouter configuration
│   ├── theme/                 # Light & dark theme
│   └── utils/                 # Currency formatter
├── data/
│   ├── local/                 # LocalStorageService
│   ├── models/                # Transaction, Category, Budget, User
│   └── repositories/          # Data access layer
├── features/
│   ├── auth/                  # Login & registration
│   ├── budgets/               # Budget management
│   ├── categories/            # Category management
│   ├── dashboard/             # Home screen & charts
│   ├── settings/              # Theme, language, currency
│   └── transactions/          # Transaction list & forms
└── l10n/                      # Localization (EN, RO, RU)

server/FamilyBudget.Api/       (.NET)
├── Data/                      # EF DbContext
├── DTOs/                      # Request/Response records
├── Endpoints/                 # Minimal API endpoint groups
├── Models/                    # EF entities
├── Program.cs                 # App entry point
├── Dockerfile
└── appsettings.json
```

## Roadmap

- [ ] Connect Flutter client to .NET API
- [ ] Cloud sync across devices
- [ ] Recurring transactions
- [ ] Export to CSV/PDF
- [ ] Budget notifications
