using System.ComponentModel.DataAnnotations;

namespace FamilyBudget.Api.Models;

public enum TransactionType
{
    Income,
    Expense
}

public class Transaction
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    [Required]
    public Guid CategoryId { get; set; }

    [Required]
    public decimal Amount { get; set; }

    [Required]
    public TransactionType Type { get; set; }

    [MaxLength(500)]
    public string Description { get; set; } = string.Empty;

    public DateTime Date { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public User User { get; set; } = null!;
    public Category Category { get; set; } = null!;
}
