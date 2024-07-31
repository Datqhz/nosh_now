using System.Transactions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Extensions;
using MyApp.Identity;
using MyApp.Models;
using MyApp.Repositories.Interface;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/food")]
    [Authorize(Policy = IdentityData.MerchantPolicyName)]
    public class FoodController : ControllerBase
    {
        private readonly IFoodRepository foodRepository;
        private readonly IMerchantRepository merchantRepository;
        public FoodController(IFoodRepository foodRepository, IMerchantRepository merchantRepository)
        {
            this.foodRepository = foodRepository;
            this.merchantRepository = merchantRepository;
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await foodRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Food has id = {id} doesn't exist."
                });
            }
            return Ok(data.AsDto());
        }
        [HttpPost]
        public async Task<IActionResult> CreateFood(CreateFood createFood)
        {
            var data = await merchantRepository.GetById(createFood.merchantId);
            if (data == null)
            {
                return BadRequest(new
                {
                    error = $"Merchant has id =  {createFood.merchantId} doesn't exist"
                });
            }
            var foodCreated = await foodRepository.Insert(new Food
            {
                FoodName = createFood.foodName,
                FoodImage = Convert.FromBase64String(createFood.foodImage),
                FoodDescribe = createFood.foodDescribe,
                Price = createFood.price,
                Status = createFood.status,
                MerchantId = createFood.merchantId
            });
            return CreatedAtAction(nameof(GetById), new { id = foodCreated.Id }, foodCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateFood(UpdateFood updateFood)
        {
            var food = await foodRepository.GetById(updateFood.id);
            if (food == null)
            {
                return NotFound(new
                {
                    error = "Food doesn't exits!"
                });
            }
            if (!string.IsNullOrEmpty(updateFood.foodImage))
            {
                food.FoodImage = Convert.FromBase64String(updateFood.foodImage);
            }
            food.FoodName = updateFood.foodName;
            food.FoodDescribe = updateFood.foodDescribe;
            food.Price = updateFood.price;
            food.Status = updateFood.status;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var foodUpdated = await foodRepository.Update(food);
                scope.Complete();
                return Ok(foodUpdated.AsDto());
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await foodRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Food has id = {id} doesn't exist."
                });
            }
            await foodRepository.Delete(id);
            return Ok(data.AsDto());
        }
        [AllowAnonymous]
        [Authorize(Policy = "MerchantEater")]
        [HttpGet("sell/merchant/{id}")]
        public async Task<IActionResult> GetAllByMerchantIdAndIsSelling(int id)
        {
            var data = await foodRepository.GetByMerchantAndIsSelling(id);
            return Ok(data.Select(f => f.AsDto()).ToList());
        }
        [HttpGet("all/merchant/{id}")]
        public async Task<IActionResult> GetAllByMerchantIdWithoutCondition(int id)
        {
            var data = await foodRepository.GetByMerchantWithoutCondition(id);
            return Ok(data.Select(f => f.AsDto()).ToList());
        }
    }
}