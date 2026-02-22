using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using FamilyBudget.Api.Data;
using FamilyBudget.Api.DTOs;
using FamilyBudget.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace FamilyBudget.Api.Endpoints;

public static class AuthEndpoints
{
    public static RouteGroupBuilder MapAuthEndpoints(this RouteGroupBuilder group)
    {
        group.MapPost("/register", Register);
        group.MapPost("/login", Login);
        return group;
    }

    private static async Task<IResult> Register(RegisterRequest req, AppDbContext db, IConfiguration config)
    {
        if (await db.Users.AnyAsync(u => u.Email == req.Email.ToLower()))
            return Results.Conflict(new { message = "Email already registered" });

        var user = new User
        {
            Name = req.Name,
            Email = req.Email.ToLower(),
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(req.Password)
        };

        db.Users.Add(user);
        await db.SaveChangesAsync();

        var token = GenerateToken(user, config);
        return Results.Created($"/api/auth/{user.Id}",
            new AuthResponse(user.Id, user.Name, user.Email, token));
    }

    private static async Task<IResult> Login(LoginRequest req, AppDbContext db, IConfiguration config)
    {
        var user = await db.Users.FirstOrDefaultAsync(u => u.Email == req.Email.ToLower());
        if (user is null || !BCrypt.Net.BCrypt.Verify(req.Password, user.PasswordHash))
            return Results.Unauthorized();

        var token = GenerateToken(user, config);
        return Results.Ok(new AuthResponse(user.Id, user.Name, user.Email, token));
    }

    private static string GenerateToken(User user, IConfiguration config)
    {
        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(config["Jwt:Key"]!));

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(ClaimTypes.Name, user.Name)
        };

        var token = new JwtSecurityToken(
            issuer: config["Jwt:Issuer"],
            audience: config["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(7),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256));

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
