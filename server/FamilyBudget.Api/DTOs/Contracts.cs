namespace FamilyBudget.Api.DTOs;

// === Auth ===
public record RegisterRequest(string Name, string Email, string Password);
public record LoginRequest(string Email, string Password);
public record AuthResponse(Guid Id, string Name, string Email, string Token);

// === Category ===
public record CategoryRequest(string Name, int IconCodePoint, int ColorValue);
public record CategoryResponse(Guid Id, string Name, int IconCodePoint, int ColorValue);

// === Transaction ===
public record TransactionRequest(decimal Amount, string Type, Guid CategoryId, string Description, DateTime Date);
public record TransactionResponse(Guid Id, decimal Amount, string Type, Guid CategoryId, string Description, DateTime Date, DateTime CreatedAt);

// === Budget ===
public record BudgetRequest(Guid CategoryId, decimal Limit, decimal Spent, int Month, int Year);
public record BudgetResponse(Guid Id, Guid CategoryId, decimal Limit, decimal Spent, int Month, int Year);
