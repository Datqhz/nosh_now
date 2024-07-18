using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using MyApp.Dtos.Request;
using MyApp.Dtos.Response;
using MyApp.Extensions;
using MyApp.Models;
using MyApp.Repositories.Interface;
using MyApp.Utils;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/merchant")]
    public class MerchantController : ControllerBase
    {

        private readonly IMerchantRepository merchantRepository;
        private readonly ICategoryRepository categoryRepository;
        private readonly IAccountRepository accountRepository;
        public MerchantController(IMerchantRepository merchantRepository, ICategoryRepository categoryRepository, IAccountRepository accountRepository)
        {
            this.merchantRepository = merchantRepository;
            this.categoryRepository = categoryRepository;
            this.accountRepository = accountRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await merchantRepository.GetAll();
            return Ok(data.Select(merchant => merchant.AsDto()).ToList());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await merchantRepository.GetById(id);
            if (data == null)
            {
                return NotFound(new
                {
                    error = $"Merchant has id = {id} doesn't exist."
                });
            }
            return Ok(data.AsDto());
        }

        [HttpPost]
        public async Task<IActionResult> CreateMerchant(CreateMerchant createMerchant)
        {
            var category = await categoryRepository.GetById(createMerchant.categoryId);
            if (category == null)
            {
                return NotFound(new
                {
                    error = $"Category has id = {createMerchant.categoryId} doesn't exist."
                });
            }
            var account = await accountRepository.GetById(createMerchant.accountId);
            if (account == null)
            {
                return NotFound(new
                {
                    error = $"Account has id = {createMerchant.accountId} doesn't exist."
                });
            }
            var merchantCreated = await merchantRepository.Insert(new Merchant
            {
                DisplayName = createMerchant.displayName,
                Avatar = Convert.FromBase64String(createMerchant.avatar),
                Phone = createMerchant.phone,
                Email = createMerchant.email,
                OpeningTime = createMerchant.openingTime,
                ClosingTime = createMerchant.closingTime,
                Coordinator = createMerchant.coordinator,
                AccountId = createMerchant.accountId,
                CategoryId = createMerchant.categoryId
            }
            );
            return CreatedAtAction(nameof(GetById), new { id = merchantCreated.Id }, merchantCreated.AsDto());
        }
        [HttpPut]
        public async Task<IActionResult> UpdateOrderStatus(UpdateMerchant updateMerchant)
        {
            var merchant = await merchantRepository.GetById(updateMerchant.id);
            if (merchant == null)
            {
                return NotFound(new
                {
                    error = "Merchant doesn't exits!"
                });
            }
            var category = await categoryRepository.GetById(updateMerchant.categoryId);
            if (category == null)
            {
                return NotFound(new
                {
                    error = $"Category has id = {updateMerchant.categoryId} doesn't exist."
                });
            }
            if (!string.IsNullOrEmpty(updateMerchant.avatar))
            {
                merchant.Avatar = Convert.FromBase64String(updateMerchant.avatar);
            }
            merchant.DisplayName = updateMerchant.displayName;
            merchant.Phone = updateMerchant.phone;
            merchant.OpeningTime = updateMerchant.openingTime;
            merchant.ClosingTime = updateMerchant.closingTime;
            merchant.Coordinator = updateMerchant.coordinator;
            merchant.CategoryId = updateMerchant.categoryId;

            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var merchantUpdated = await merchantRepository.Update(merchant);
                scope.Complete();
                return Ok(merchantUpdated.AsDto());
            }
        }
        [HttpGet("find")]
        public async Task<IActionResult> FindContainRegex([FromQuery] string regex)
        {
            var data = await merchantRepository.FindContainRegex(regex);
            return Ok(data.Select(merchant => merchant.AsDto()).ToList());
        }

        [HttpGet("near-by")]
        public async Task<IActionResult> GetMerchantNearBy([FromQuery] string coordinator)
        {
            var data = await merchantRepository.GetAllMerchantIsOpening();
            List<MerchantAndDistanceResponseDto> merchants = new List<MerchantAndDistanceResponseDto>();
            foreach (var merchant in data)
            {
                double distance = DistanceUtil.CalculateDistance(coordinator, merchant.Coordinator);
                Console.WriteLine($"distance {distance}");
                if (distance < 10000)
                {
                    merchants.Add(new MerchantAndDistanceResponseDto(merchant.AsDto(), distance));
                }
            }
            SortUtil.SortOrderByDistance(merchants, 0, merchants.Count - 1);
            return Ok(merchants);
        }
    }
}