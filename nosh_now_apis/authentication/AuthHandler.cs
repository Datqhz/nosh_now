using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace MyApp.Authentication
{
    public class AuthHandler
    {
        string AUTH_ISSUER;
        string AUTH_AUDIENCE;
        string AUTH_KEY;
        public AuthHandler()
        {
            // string rootFolderPath = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, ".env");
            // DotNetEnv.Env.Load(rootFolderPath);
            AUTH_ISSUER = Environment.GetEnvironmentVariable("ISSUER");
            AUTH_AUDIENCE = Environment.GetEnvironmentVariable("AUDIENCE");
            AUTH_KEY = Environment.GetEnvironmentVariable("KEY");
        }
        public string GenerateToken(string email, string accountId, string groupName)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Sub, email),
                new Claim(JwtRegisteredClaimNames.Email, email),
                new ("accountid", accountId),
                new ("role",groupName)
            };
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                AUTH_KEY
            ));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256Signature);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(30),
                Issuer = AUTH_ISSUER,
                Audience = AUTH_AUDIENCE,
                SigningCredentials = creds
            };
            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            var jwt = tokenHandler.WriteToken(token);
            return jwt;
        }

    }
}