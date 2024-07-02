using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/manager")]
    public class ManagerController : ControllerBase
    {

        private readonly IRepository<Manager> managerRepository;
        private readonly IAccountRepository accountRepository;
        public ManagerController(IRepository<Manager> managerRepository, IAccountRepository accountRepository)
        {
            this.managerRepository = managerRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await managerRepository.GetAll();
            return Ok(data);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await managerRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Manager has id = {id} doesn't exist."
                });
            }
            return Ok(data);
        }

        [HttpPost]
        public async Task<IActionResult> CreateManager(CreateEaterOrManager createManager)
        {
            var account = await accountRepository.GetById(createManager.accountId);
            if(account == null)
            {
                return NotFound(new 
                {
                    error = $"Account has id = {createManager.accountId} doesn't exist."
                });
            }
            var managerCreated = await managerRepository.Insert(new Manager
            {
                DisplayName = createManager.displayName,
                Avatar = Convert.FromBase64String(createManager.avatar),
                Phone = createManager.phone,
                Email = createManager.email,
                AccountId = createManager.accountId
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = managerCreated.Id }, managerCreated);
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrderStatus(UpdateEaterOrManager updateManager)
        {
            var manager = await managerRepository.GetById(updateManager.id);
            if(manager == null){
                return NotFound(new
                {
                    error = "Manager doesn't exits!"
                });
            }
            if(!string.IsNullOrEmpty(updateManager.avatar))
            {
                manager.Avatar = Convert.FromBase64String(updateManager.avatar);
            }
            manager.DisplayName = updateManager.displayName;
            manager.Phone = updateManager.phone;

            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var managerUpdated = await managerRepository.Update(manager);
                scope.Complete();
                return Ok(managerUpdated);
            }
        }
    }
}