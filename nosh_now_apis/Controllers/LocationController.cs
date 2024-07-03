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
    [Route("api/location")]
    public class LocationController : ControllerBase
    {

        private readonly ILocationRepository locationRepository;
        private readonly IEaterRepository eaterRepository;
        public LocationController(ILocationRepository locationRepository, IEaterRepository eaterRepository)
        {
            this.locationRepository = locationRepository;
            this.eaterRepository = eaterRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await locationRepository.GetAll();
            return Ok(data.Select(location => location.AsDto()).ToList());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await locationRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Location has id = {id} doesn't exist."
                });
            }
            return Ok(data.AsDto());
        }

        [HttpPost]
        public async Task<IActionResult> CreateLocation(CreateLocation createLocation)
        {
            var eater = await eaterRepository.GetById(createLocation.eaterId);
            if(eater == null)
            {
                return NotFound(new 
                {
                    error = $"Eater has id = {createLocation.eaterId} doesn't exist."
                });
            }
            var locationCreated = await locationRepository.Insert(new Location
            {
                LocationName = createLocation.locationName,
                Coordinator = createLocation.coordinator,
                Default = createLocation.defaultLocation,
                EaterId = createLocation.eaterId
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = locationCreated.Id }, locationCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrderStatus(UpdateLocation updateLocation)
        {
            var location = await locationRepository.GetById(updateLocation.id);
            if(location == null){
                return NotFound(new
                {
                    error = "Location doesn't exits!"
                });
            }
            location.LocationName = updateLocation.locationName;
            location.Coordinator = updateLocation.coordinator;
            location.Default = updateLocation.defaultLocation;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var locationUpdated = await locationRepository.Update(location);
                scope.Complete();
                return Ok(locationUpdated.AsDto());
            }
        }
        [HttpGet("user/{id}")]
        public async Task<IActionResult> FindContainRegex(int id)
        {
            var data = await locationRepository.FindByEater(id);
            return Ok(data.Select(location => location.AsDto()).ToList());
        }
        [HttpGet("default/user/{id}")]
        public async Task<IActionResult> FindDefaultLocationByEater(int id)
        {
            var data = await locationRepository.GetDefaultByEater(id);
            return Ok(data.AsDto());
        }
    }
}