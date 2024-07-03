using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/account")]
    public class AccountController : ControllerBase
    {

        private readonly IAccountRepository accountRepository;
        public AccountController(IAccountRepository accountRepository)
        {
            this.accountRepository = accountRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await accountRepository.GetAll();
            return Ok(data);
        }

        [HttpGet("{id}")]
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
        public async Task<IActionResult> UpdateOrderStatus(UpdateAccount updateAccount)
        {
            var account = await accountRepository.GetById(updateAccount.id);
            if(account == null){
                return NotFound(new
                {
                    error = "Account doesn't exits!"
                });
            }
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(updateAccount.password);
            account.Password = passwordHash;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var accountUpdated = await accountRepository.Update(account);
                scope.Complete();
                return Ok(accountUpdated);
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
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(loginDto.password);
            if(verify)
            {
                return Ok(account);
            }
            return BadRequest(new
            {
                error = "Incorrect account or password"
            });
            
        }
    }
}