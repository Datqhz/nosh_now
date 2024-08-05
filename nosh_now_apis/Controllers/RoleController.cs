using System.Transactions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Identity;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    // [Authorize(Policy = IdentityData.ManagerPolicyName)]
    [ApiController]
    [Route("api/role")]
    public class RoleController : ControllerBase
    {

        private readonly IRoleRepository roleRepository;
        public RoleController(IRoleRepository roleRepository)
        {
            this.roleRepository = roleRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await roleRepository.GetAll();
            return Ok(data);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await roleRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Role has id = {id} doesn't exist."
                });
            }
            return Ok(data);
        }
        [HttpPost]
        public async Task<IActionResult> CreateRole(CreateRole createRole)
        {
            var data = await roleRepository.FindByName(createRole.roleName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"Role name =  {createRole.roleName} was used."
                });
            }
            var roleCreated = await roleRepository.Insert(new Role
            {
                RoleName = createRole.roleName,
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = roleCreated.Id }, roleCreated);
        }
        [HttpPut]
        public async Task<IActionResult> UpdateRole(UpdateRole updateRole)
        {
            var role = await roleRepository.GetById(updateRole.id);
            if(role == null){
                return NotFound(new
                {
                    error = "Role doesn't exits!"
                });
            }
            var data = await roleRepository.FindByName(updateRole.roleName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"Role name =  {updateRole.roleName} was used."
                });
            }
            role.RoleName = updateRole.roleName;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var roleUpdated = await roleRepository.Update(role);
                scope.Complete();
                return Ok(roleUpdated);
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await roleRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Role has id = {id} doesn't exist."
                });
            }
            await roleRepository.Delete(id);
            return Ok(data);
        }
    }
}