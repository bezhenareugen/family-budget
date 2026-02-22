using System.Text;
using FamilyBudget.Api.Data;
using FamilyBudget.Api.Endpoints;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// === Database ===
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// === Authentication ===
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!))
        };
    });
builder.Services.AddAuthorization();

// === CORS ===
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});



var app = builder.Build();

// === Middleware ===
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();



// === Endpoints ===
app.MapGroup("/api/auth")
    .MapAuthEndpoints()
    .WithTags("Auth");

app.MapGroup("/api/categories")
    .MapCategoryEndpoints()
    .RequireAuthorization()
    .WithTags("Categories");

app.MapGroup("/api/transactions")
    .MapTransactionEndpoints()
    .RequireAuthorization()
    .WithTags("Transactions");

app.MapGroup("/api/budgets")
    .MapBudgetEndpoints()
    .RequireAuthorization()
    .WithTags("Budgets");

// === Auto-migrate in development ===
if (app.Environment.IsDevelopment())
{
    using var scope = app.Services.CreateScope();
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    await db.Database.MigrateAsync();
}

app.Run();
