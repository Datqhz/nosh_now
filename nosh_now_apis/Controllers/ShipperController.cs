using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Extensions;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/shipper")]
    public class ShipperController : ControllerBase
    {

        private readonly IShipperRepository shipperRepository;
        private readonly IVehicleTypeRepository vehicleTypeRepository;
        private readonly IAccountRepository accountRepository;
        public ShipperController(IShipperRepository shipperRepository, IVehicleTypeRepository vehicleTypeRepository, IAccountRepository accountRepository)
        {
            this.shipperRepository = shipperRepository;
            this.vehicleTypeRepository = vehicleTypeRepository;
            this.accountRepository = accountRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await shipperRepository.GetAll();
            return Ok(data.Select(shipper => shipper.AsDto()).ToList());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await shipperRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Shipper has id = {id} doesn't exist."
                });
            }
            return Ok(data.AsDto());
        }

        [HttpPost]
        public async Task<IActionResult> CreateShipper(CreateShipper createShipper)
        {
            var vehicleType = await vehicleTypeRepository.GetById(createShipper.vehicleTypeId);
            if(vehicleType == null)
            {
                return NotFound(new 
                {
                    error = $"Vehicle type has id = {createShipper.vehicleTypeId} doesn't exist."
                });
            }
            var account = await accountRepository.GetById(createShipper.accountId);
            if(account == null)
            {
                return NotFound(new 
                {
                    error = $"Account has id = {createShipper.accountId} doesn't exist."
                });
            }
            var shipperCreated = await shipperRepository.Insert(new Shipper
            {
                DisplayName = createShipper.displayName,
                Avatar = Convert.FromBase64String(createShipper.avatar),
                Phone = createShipper.phone,
                Email = createShipper.email,
                VehicleName = createShipper.vehicleName,
                MomoPayment = createShipper.momoPayment,
                Coordinator = createShipper.coordinator,
                AccountId = createShipper.accountId,
                VehicleTypeId = createShipper.vehicleTypeId
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = shipperCreated.Id }, shipperCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrderStatus(UpdateShipper updateShipper)
        {
            var shipper = await shipperRepository.GetById(updateShipper.id);
            if(shipper == null){
                return NotFound(new
                {
                    error = "Shipper doesn't exits!"
                });
            }
            var vehicleType = await vehicleTypeRepository.GetById(updateShipper.vehicleTypeId);
            if(vehicleType == null)
            {
                return NotFound(new 
                {
                    error = $"Vehicle type has id = {updateShipper.vehicleTypeId} doesn't exist."
                });
            }
            if(!string.IsNullOrEmpty(updateShipper.avatar))
            {
                shipper.Avatar = Convert.FromBase64String(updateShipper.avatar);
            }
            shipper.DisplayName = updateShipper.displayName;
            shipper.Phone = updateShipper.phone;
            shipper.VehicleName = updateShipper.vehicleName;
            shipper.MomoPayment = updateShipper.momoPayment;
            shipper.Coordinator = updateShipper.coordinator;
            shipper.VehicleTypeId = updateShipper.vehicleTypeId;

            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var shipperUpdated = await shipperRepository.Update(shipper);
                scope.Complete();
                return Ok(shipperUpdated.AsDto());
            }
        }
        [HttpGet("find")]
        public async Task<IActionResult> FindContainRegex([FromQuery] string regex)
        {
            var data = await shipperRepository.FindContainRegex(regex);
            return Ok(data.Select(shipper => shipper.AsDto()).ToList());
        }
    }
}