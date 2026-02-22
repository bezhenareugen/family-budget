using System.Security.Claims;
using FamilyBudget.Api.Data;
using FamilyBudget.Api.DTOs;
using FamilyBudget.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace FamilyBudget.Api.Endpoints;

public static class BudgetEndpoints
{
    public static RouteGroupBuilder MapBudgetEndpoints(this RouteGroupBuilder group)
    {
        group.MapGet("/", GetAll);
        group.MapPost("/", Create);
        group.MapPut("/{id:guid}", Update);
        group.MapDelete("/{id:guid}", Delete);
        return group;
    }

    private static Guid GetUserId(HttpContext ctx) =>
        Guid.Parse(ctx.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    private static async Task<IResult> GetAll(
        HttpContext ctx, AppDbContext db, int? month, int? year)
    {
        var userId = GetUserId(ctx);
        var query = db.Budgets.Where(b => b.UserId == userId);

        if (month.HasValue) query = query.Where(b => b.Month == month.Value);
        if (year.HasValue) query = query.Where(b => b.Year == year.Value);

        var budgets = await query
            .Select(b => new BudgetResponse(b.Id, b.CategoryId, b.Limit, b.Spent, b.Month, b.Year))
            .ToListAsync();

        return Results.Ok(budgets);
    }

    private static async Task<IResult> Create(HttpContext ctx, BudgetRequest req, AppDbContext db)
    {
        var userId = GetUserId(ctx);

        var exists = await db.Budgets.AnyAsync(b =>
            b.UserId == userId && b.CategoryId == req.CategoryId &&
            b.Month == req.Month && b.Year == req.Year);
        if (exists) return Results.Conflict(new { message = "Budget already exists for this category and period." });

        var budget = new Budget
        {
            UserId = userId,
            CategoryId = req.CategoryId,
            Limit = req.Limit,
            Spent = req.Spent,
            Month = req.Month,
            Year = req.Year
        };

        db.Budgets.Add(budget);
        await db.SaveChangesAsync();

        return Results.Created($"/api/budgets/{budget.Id}",
            new BudgetResponse(budget.Id, budget.CategoryId, budget.Limit, budget.Spent, budget.Month, budget.Year));
    }

    private static async Task<IResult> Update(Guid id, HttpContext ctx, BudgetRequest req, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var budget = await db.Budgets.FirstOrDefaultAsync(b => b.Id == id && b.UserId == userId);
        if (budget is null) return Results.NotFound();

        budget.CategoryId = req.CategoryId;
        budget.Limit = req.Limit;
        budget.Spent = req.Spent;
        budget.Month = req.Month;
        budget.Year = req.Year;
        await db.SaveChangesAsync();

        return Results.Ok(new BudgetResponse(budget.Id, budget.CategoryId, budget.Limit, budget.Spent, budget.Month, budget.Year));
    }

    private static async Task<IResult> Delete(Guid id, HttpContext ctx, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var budget = await db.Budgets.FirstOrDefaultAsync(b => b.Id == id && b.UserId == userId);
        if (budget is null) return Results.NotFound();

        db.Budgets.Remove(budget);
        await db.SaveChangesAsync();
        return Results.NoContent();
    }
}
