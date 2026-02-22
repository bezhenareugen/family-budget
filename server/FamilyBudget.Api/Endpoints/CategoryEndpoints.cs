using System.Security.Claims;
using FamilyBudget.Api.Data;
using FamilyBudget.Api.DTOs;
using FamilyBudget.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace FamilyBudget.Api.Endpoints;

public static class CategoryEndpoints
{
    public static RouteGroupBuilder MapCategoryEndpoints(this RouteGroupBuilder group)
    {
        group.MapGet("/", GetAll);
        group.MapPost("/", Create);
        group.MapPut("/{id:guid}", Update);
        group.MapDelete("/{id:guid}", Delete);
        return group;
    }

    private static Guid GetUserId(HttpContext ctx) =>
        Guid.Parse(ctx.User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    private static async Task<IResult> GetAll(HttpContext ctx, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var categories = await db.Categories
            .Where(c => c.UserId == userId)
            .Select(c => new CategoryResponse(c.Id, c.Name, c.IconCodePoint, c.ColorValue))
            .ToListAsync();
        return Results.Ok(categories);
    }

    private static async Task<IResult> Create(HttpContext ctx, CategoryRequest req, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var category = new Category
        {
            UserId = userId,
            Name = req.Name,
            IconCodePoint = req.IconCodePoint,
            ColorValue = req.ColorValue
        };

        db.Categories.Add(category);
        await db.SaveChangesAsync();

        return Results.Created($"/api/categories/{category.Id}",
            new CategoryResponse(category.Id, category.Name, category.IconCodePoint, category.ColorValue));
    }

    private static async Task<IResult> Update(Guid id, HttpContext ctx, CategoryRequest req, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var category = await db.Categories.FirstOrDefaultAsync(c => c.Id == id && c.UserId == userId);
        if (category is null) return Results.NotFound();

        category.Name = req.Name;
        category.IconCodePoint = req.IconCodePoint;
        category.ColorValue = req.ColorValue;
        await db.SaveChangesAsync();

        return Results.Ok(new CategoryResponse(category.Id, category.Name, category.IconCodePoint, category.ColorValue));
    }

    private static async Task<IResult> Delete(Guid id, HttpContext ctx, AppDbContext db)
    {
        var userId = GetUserId(ctx);
        var category = await db.Categories.FirstOrDefaultAsync(c => c.Id == id && c.UserId == userId);
        if (category is null) return Results.NotFound();

        db.Categories.Remove(category);
        await db.SaveChangesAsync();
        return Results.NoContent();
    }
}
