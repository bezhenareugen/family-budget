using System.ComponentModel.DataAnnotations;

namespace FamilyBudget.Api.Models;

public class Category
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    public int IconCodePoint { get; set; }

    public int ColorValue { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public User User { get; set; } = null!;
    public ICollection<Transaction> Transactions { get; set; } = [];
    public ICollection<Budget> Budgets { get; set; } = [];
}
