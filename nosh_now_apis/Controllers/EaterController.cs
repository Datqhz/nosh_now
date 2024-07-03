using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Extensions;
using MyApp.Models;
using MyApp.Repositories.Interface;
using MyApp.Utils;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/eater")]
    public class EaterController : ControllerBase
    {

        private readonly IEaterRepository eaterRepository;
        private readonly IAccountRepository accountRepository;
        public EaterController(IEaterRepository eaterRepository, IAccountRepository accountRepository)
        {
            this.eaterRepository = eaterRepository;
            this.accountRepository = accountRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await eaterRepository.GetAll();
            return Ok(data.Select(eater => eater.AsDto()).ToList());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await eaterRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Eater has id = {id} doesn't exist."
                });
            }
            return Ok(data.AsDto());
        }

        [HttpPost]
        public async Task<IActionResult> CreateEater(CreateEaterOrManager createEater)
        {
            var account = await accountRepository.GetById(createEater.accountId);
            if(account == null)
            {
                return NotFound(new 
                {
                    error = $"Account has id = {createEater.accountId} doesn't exist."
                });
            }
            var eaterCreated = await eaterRepository.Insert(new Eater
            {
                DisplayName = createEater.displayName,
                Avatar = Convert.FromBase64String(createEater.avatar),
                Phone = createEater.phone,
                Email = createEater.email,
                AccountId = createEater.accountId
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = eaterCreated.Id }, eaterCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrderStatus(UpdateEaterOrManager updateEater)
        {
            var eater = await eaterRepository.GetById(updateEater.id);
            if(eater == null){
                return NotFound(new
                {
                    error = "Eater doesn't exits!"
                });
            }
            if(!string.IsNullOrEmpty(updateEater.avatar))
            {
                eater.Avatar = Convert.FromBase64String(updateEater.avatar);
            }
            eater.DisplayName = updateEater.displayName;
            eater.Phone = updateEater.phone;

            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var eaterUpdated = await eaterRepository.Update(eater);
                scope.Complete();
                return Ok(eaterUpdated.AsDto());
            }
        }
        [HttpGet("find")]
        public async Task<IActionResult> FindContainRegex([FromQuery] string regex)
        {
            var data = await eaterRepository.FindContainRegex(regex);
            return Ok(data.Select(eater => eater.AsDto()).ToList());
        }
    }
}