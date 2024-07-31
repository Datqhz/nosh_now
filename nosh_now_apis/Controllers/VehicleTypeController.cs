using System.Transactions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Identity;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [Authorize(Policy = IdentityData.ManagerPolicyName)]
    [ApiController]
    [Route("api/vehicleType")]
    public class VehicleTypeController : ControllerBase
    {

        private readonly IVehicleTypeRepository vehicleTypeRepository;
        public VehicleTypeController(IVehicleTypeRepository vehicleTypeRepository)
        {
            this.vehicleTypeRepository = vehicleTypeRepository;
        }
        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await vehicleTypeRepository.GetAll();
            return Ok(data);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await vehicleTypeRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Vehicle type has id = {id} doesn't exist."
                });
            }
            return Ok(data);
        }
        [HttpPost]
        public async Task<IActionResult> CreateVehicleType(CreateVehicleType createVehicleType)
        {
            var data = await vehicleTypeRepository.FindByName(createVehicleType.typeName);
            if (data.Any())
            {
                return BadRequest(new
                {
                    error = $"Vehicle type name =  {createVehicleType.typeName} was used."
                });
            }
            var vehicleTypeCreated = await vehicleTypeRepository.Insert(new VehicleType
            {
                TypeName = createVehicleType.typeName,
                Icon = Convert.FromBase64String(createVehicleType.image)
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = vehicleTypeCreated.Id }, vehicleTypeCreated);
        }
        [HttpPut]
        public async Task<IActionResult> UpdateVehicleType(UpdateVehicleType updateVehicleType)
        {
            var vehicleType = await vehicleTypeRepository.GetById(updateVehicleType.id);
            if (vehicleType == null)
            {
                return NotFound(new
                {
                    error = "Vehicle type doesn't exits!"
                });
            }
            if (vehicleType.TypeName.Equals(updateVehicleType.typeName))
            {
                var data = await vehicleTypeRepository.FindByName(updateVehicleType.typeName);
                if (data.Any())
                {
                    return BadRequest(new
                    {
                        error = $"Vehicle type name =  {updateVehicleType.typeName} was used."
                    });
                }
            }
            vehicleType.TypeName = updateVehicleType.typeName;
            if (updateVehicleType.image != "")
            {
                vehicleType.Icon = Convert.FromBase64String(updateVehicleType.image);
            }
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var vehicleTypeUpdated = await vehicleTypeRepository.Update(vehicleType);
                scope.Complete();
                return Ok(vehicleTypeUpdated);
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await vehicleTypeRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Vehicle type has id = {id} doesn't exist."
                });
            }
            await vehicleTypeRepository.Delete(id);
            return Ok(data);
        }
    }
}