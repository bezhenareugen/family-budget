using System.ComponentModel.DataAnnotations;

namespace FamilyBudget.Api.Models;

public class User
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required, MaxLength(200)]
    public string Email { get; set; } = string.Empty;

    [Required]
    public string PasswordHash { get; set; } = string.Empty;

    public string? AvatarUrl { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public ICollection<Transaction> Transactions { get; set; } = [];
    public ICollection<Category> Categories { get; set; } = [];
    public ICollection<Budget> Budgets { get; set; } = [];
}
