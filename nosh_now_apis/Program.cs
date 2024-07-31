using MyApp.Authentication;
using MyApp.DbContexts;
using MyApp.Models;
using MyApp.Repositories;
using MyApp.Repositories.Interface;
using MyApp.Repository;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddAuthenticationSetting().AddAuthorizationSetting();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins",
        builder =>
        {
            builder.AllowAnyOrigin()
                   .AllowAnyMethod()
                   .AllowAnyHeader();
        });
});
// Add services to the container.
builder.Services.AddDbContext<MyAppContext>();
builder.Services.AddSingleton<AuthHandler, AuthHandler>();
builder.Services.AddTransient<IAccountRepository, AccountRepository>();
builder.Services.AddTransient<ICategoryRepository, CategoryRepository>();
builder.Services.AddTransient<IOrderStatusRepository, OrderStatusRepository>();
builder.Services.AddTransient<IPaymentMethodRepository, PaymentMethodRepository>();
builder.Services.AddTransient<IRoleRepository, RoleRepository>();
builder.Services.AddTransient<IVehicleTypeRepository, VehicleTypeRepository>();
builder.Services.AddTransient<IEaterRepository, EaterRepository>();
builder.Services.AddTransient<IRepository<Manager>, ManagerRepository>();
builder.Services.AddTransient<IMerchantRepository, MerchantRepository>();
builder.Services.AddTransient<IShipperRepository, ShipperRepository>();
builder.Services.AddTransient<IFoodRepository, FoodRepository>();
builder.Services.AddTransient<ILocationRepository, LocationRepository>();
builder.Services.AddTransient<IOrderDetailRepository, OrderDetailRepository>();
builder.Services.AddTransient<IOrderRepository, OrderRepository>();
builder.Services.AddTransient<IStatisticRepository, StatisticRepository>();
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAllOrigins");
app.UseMiddleware<ErrorHandlingMiddleware>();
// app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
