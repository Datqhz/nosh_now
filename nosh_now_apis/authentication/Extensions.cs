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
                option.AddPolicy("ManagerEater", policy =>
                    policy.RequireAssertion(context =>
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.ManagerPolicyName) ||
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.EaterPolicyName))
                );
                option.AddPolicy("ManagerMerchant", policy =>
                    policy.RequireAssertion(context =>
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.ManagerPolicyName) ||
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.MerchantPolicyName))
                );
                option.AddPolicy("ManagerShipper", policy =>
                    policy.RequireAssertion(context =>
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.ManagerPolicyName) ||
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.ShipperPolicyName))
                );
                option.AddPolicy("MerchantEater", policy =>
                    policy.RequireAssertion(context =>
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.MerchantPolicyName) ||
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.EaterPolicyName))
                );
                option.AddPolicy("ShipperEater", policy =>
                    policy.RequireAssertion(context =>
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.ShipperPolicyName) ||
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.EaterPolicyName))
                );
                option.AddPolicy("MerchantShipper", policy =>
                    policy.RequireAssertion(context =>
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.MerchantPolicyName) ||
                    context.User.HasClaim(c => c.Type == IdentityData.ClaimName && c.Value == IdentityData.ShipperPolicyName))
                );
            });
            return services;
        }
    }
}