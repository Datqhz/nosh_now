using System.Transactions;
using BCrypt.Net;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyApp.Authentication;
using MyApp.Dtos.Request;
using MyApp.Extensions;
using MyApp.Identity;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{

    [ApiController]
    [Route("api/account")]
    public class AccountController : ControllerBase
    {
        private readonly AuthHandler authHandler;
        private readonly IAccountRepository accountRepository;
        // private readonly IRoleRepository roleRepository;
        public AccountController(IAccountRepository accountRepository, AuthHandler authHandler)
        {
            this.accountRepository = accountRepository;
            this.authHandler = authHandler;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await accountRepository.GetAll();
            return Ok(data);
        }


        [HttpGet("{id}")]
        [Authorize(IdentityData.ManagerPolicyName)]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await accountRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Account has id = {id} doesn't exist."
                });
            }
            return Ok(data);
        }

        [HttpPost]
        public async Task<IActionResult> CreateAccount(CreateAccount createAccount)
        {
            var data = await accountRepository.FindByEmail(createAccount.email);
            if (data != null)
            {
                return BadRequest(new
                {
                    error = $"Email {createAccount.email} was used."
                });
            }
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(createAccount.password);
            var accountCreated = await accountRepository.Insert(new Account
            {
                Email = createAccount.email,
                Password = passwordHash,
                RoleId = createAccount.roleId,
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = accountCreated.Id }, accountCreated);
        }
        [HttpPut]
        public async Task<IActionResult> UpdateAccont(UpdateAccount updateAccount)
        {
            var account = await accountRepository.GetById(updateAccount.id);
            if (account == null)
            {
                return NotFound(new
                {
                    error = "Account doesn't exits!"
                });
            }
            if(!BCrypt.Net.BCrypt.Verify(updateAccount.oldPassword, account.Password)){
                return BadRequest(new {
                    error = "Your old password is incorrect"
                });
            }
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(updateAccount.newPassword);
            account.Password = passwordHash;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                await accountRepository.Update(account);
                scope.Complete();
                return Ok();
            }
        }
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginRequest loginDto)
        {
            var account = await accountRepository.FindByEmail(loginDto.email);
            if (account == null)
            {
                return BadRequest(new
                {
                    error = "Incorrect account or password"
                });
            }

            var verify = BCrypt.Net.BCrypt.Verify(loginDto.password, account.Password);
            if (verify)
            {
                string token = authHandler.GenerateToken(account.Email, account.Id.ToString(), account.Role.RoleName);
                var response = new Dictionary<string, object>
                {
                    { "token", token},
                    { "user", "new_data" }
                };
                if (account.Role.RoleName == "Manager")
                {
                    response["user"] = account.Manager.AsDto();
                }
                else if (account.Role.RoleName == "Eater")
                {
                    response["user"] = account.Eater.AsDto();
                }
                else if (account.Role.RoleName == "Merchant")
                {
                    response["user"] = account.Merchant.AsDto();
                }
                else
                {
                    response["user"] = account.Shipper.AsDto();
                }
                return Ok(response);
            }
            return BadRequest(new
            {
                error = "Incorrect account or password"
            });

        }
    }
}