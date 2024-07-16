using System.Text;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using MyApp.Identity;

namespace MyApp.Authentication
{
    public static class Extensions
    {
        public static IServiceCollection AddAuthenticationSetting(this IServiceCollection services)
        {
            // string rootFolderPath = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "nosh_now_apis\\.env");
            // DotNetEnv.Env.Load(rootFolderPath);
            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(x =>
            {
                x.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidIssuer = Environment.GetEnvironmentVariable("ISSUER"),
                    ValidAudience = Environment.GetEnvironmentVariable("AUDIENCE"),
                    IssuerSigningKey = new SymmetricSecurityKey(
                        System.Text.Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("KEY"))
                    ),
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true

                };
                x.MapInboundClaims = false;
            });
            return services;
        }
        public static IServiceCollection AddAuthorizationSetting(this IServiceCollection services)
        {
            services.AddAuthorization(option =>
            {
                option.AddPolicy(IdentityData.ManagerPolicyName, p =>
                {
                    p.RequireClaim(IdentityData.ClaimName, "Manager");
                });
                option.AddPolicy(IdentityData.EaterPolicyName, p =>
                {
                    p.RequireClaim(IdentityData.ClaimName, "Eater");
                });
                option.AddPolicy(IdentityData.MerchantPolicyName, p =>
                {
                    p.RequireClaim(IdentityData.ClaimName, "Merchant");
                });
                option.AddPolicy(IdentityData.ShipperPolicyName, p =>
                {
                    p.RequireClaim(IdentityData.ClaimName, "Shipper");
                });
            });
            return services;
        }
    }
}