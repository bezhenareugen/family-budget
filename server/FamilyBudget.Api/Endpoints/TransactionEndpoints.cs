using System.Security.Claims;
using FamilyBudget.Api.Data;
using FamilyBudget.Api.DTOs;
using FamilyBudget.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace FamilyBudget.Api.Endpoints;

public static class TransactionEndpoints
{
    public static RouteGroupBuilder MapTransactionEndpoints(this RouteGroupBuilder group)
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
        HttpContext ctx, AppDbContext db,
        DateTime? startDate, DateTime? endDate, Guid? categoryId)
    {
        var userId = GetUserId(ctx);
        var query = db.Transactions.Where(t => t.UserId == userId);

        if (startDate.HasValue) query = query.Where(t => t.Date >= startDate.Value);
        if (endDate.HasValue) query = query.Where(t => t.Date <= endDate.Value);
        if (categoryId.HasValue) query = query.Where(t => t.CategoryId == categoryId.Value);

        var transactions = await query
            .OrderByDescending(t => t.Date)
            .Select(t => new TransactionResponse(
                t.Id, t.Amount, t.Type.ToString().ToLower(),
                t.CategoryId, t.Description, t.Date, t.CreatedAt))
            .ToListAsync();

        return Results.Ok(transactions);
    }

    private static async Task<IResult> Create(HttpContext ctx, TransactionRequest req, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        if (!Enum.TryParse<TransactionType>(req.Type, true, out var type))
            return Results.BadRequest(new { message = "Invalid transaction type. Use 'income' or 'expense'." });

        var transaction = new Transaction
        {
            UserId = userId,
            CategoryId = req.CategoryId,
            Amount = req.Amount,
            Type = type,
            Description = req.Description,
            Date = req.Date
        };

        db.Transactions.Add(transaction);
        await db.SaveChangesAsync();

        return Results.Created($"/api/transactions/{transaction.Id}",
            new TransactionResponse(transaction.Id, transaction.Amount, transaction.Type.ToString().ToLower(),
                transaction.CategoryId, transaction.Description, transaction.Date, transaction.CreatedAt));
    }

    private static async Task<IResult> Update(Guid id, HttpContext ctx, TransactionRequest req, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var transaction = await db.Transactions.FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);
        if (transaction is null) return Results.NotFound();

        if (!Enum.TryParse<TransactionType>(req.Type, true, out var type))
            return Results.BadRequest(new { message = "Invalid transaction type." });

        transaction.Amount = req.Amount;
        transaction.Type = type;
        transaction.CategoryId = req.CategoryId;
        transaction.Description = req.Description;
        transaction.Date = req.Date;
        await db.SaveChangesAsync();

        return Results.Ok(new TransactionResponse(transaction.Id, transaction.Amount,
            transaction.Type.ToString().ToLower(), transaction.CategoryId,
            transaction.Description, transaction.Date, transaction.CreatedAt));
    }

    private static async Task<IResult> Delete(Guid id, HttpContext ctx, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var transaction = await db.Transactions.FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);
        if (transaction is null) return Results.NotFound();

        db.Transactions.Remove(transaction);
        await db.SaveChangesAsync();
        return Results.NoContent();
    }
}
