using System.ComponentModel.DataAnnotations;

namespace FamilyBudget.Api.Models;

public class Budget
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    [Required]
    public Guid CategoryId { get; set; }

    [Required]
    public decimal Limit { get; set; }

    public decimal Spent { get; set; }

    [Required]
    public int Month { get; set; }

    [Required]
    public int Year { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public User User { get; set; } = null!;
    public Category Category { get; set; } = null!;
}
