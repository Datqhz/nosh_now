using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyApp.Repositories;

namespace MyApp.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/statistic")]
    public class StatisticController : ControllerBase
    {
        private readonly IStatisticRepository statisticRepository;
        public StatisticController(IStatisticRepository statisticRepository)
        {
            this.statisticRepository = statisticRepository;
        }
        //manager
        [HttpGet("count-account")]
        public async Task<IActionResult> CountTotalAccountByDate([FromQuery] int roleId,[FromQuery] DateTime? date = null,
         [FromQuery] int? month = null, [FromQuery] int? year = null)
        {
            var count = await statisticRepository.CountAccountByRoleAndDate(roleId, date: date, month: month, year: year);
            return Ok(new {
                count = count
            });
        }
        [HttpGet("count-order")]
        public async Task<IActionResult> CountTotalOrderByDate([FromQuery] DateTime? date = null,
         [FromQuery] int? month = null, [FromQuery] int? year = null)
        {
            var count = await statisticRepository.CountOrderByDate(date: date, month: month, year: year);
            return Ok(new {
                count = count
            });
        }
        [HttpGet("count-order/user")]
        public async Task<IActionResult> CountOrderOfUserByRoleAndDate([FromQuery] int userId, [FromQuery] int roleId,[FromQuery] DateTime? date = null,
         [FromQuery] int? month = null, [FromQuery] int? year = null)
        {
            var count = await statisticRepository.CountOrderOfUserByRoleAndDate(roleId, userId, date: date, month: month, year: year);
            return Ok(new {
                count = count
            });
        }

        [HttpGet("calc-transaction")]
        public async Task<IActionResult> CalcTotalTransactionAmountByDate([FromQuery] DateTime? date = null,
         [FromQuery] int? month = null, [FromQuery] int? year = null)
        {
            var total = await statisticRepository.CalcTotalTransactionAmountByDate(date: date, month: month, year: year);
            return Ok(new {
                total = total
            });
        }
        // merchant 
        [HttpGet("calc-revenue/merchant")]
        public async Task<IActionResult> CalcTotalRevenueOfMerchantByDate([FromQuery] int merchantId,[FromQuery] DateTime? date = null,
         [FromQuery] int? month = null, [FromQuery] int? year = null)
        {
            var total = await statisticRepository.CalcTotalRevenueOfMerchantByDate(merchantId, date: date, month: month, year: year);
            return Ok(new {
                total = total
            });
        }
        [HttpGet("calc-earning/shipper")]
        public async Task<IActionResult> CalcTotalEarningOfShipperByDate([FromQuery] int shipperId,[FromQuery] DateTime? date = null,
         [FromQuery] int? month = null, [FromQuery] int? year = null)
        {
            var total = await statisticRepository.CalcTotalEarningOfShipperByDate(shipperId, date: date, month: month, year: year);
            return Ok(new {
                total = total
            });
        }

        [HttpGet("top-food")]
        public async Task<IActionResult> Top5Food([FromQuery] int merchantId,[FromQuery] DateTime? date = null,
         [FromQuery] int? month = null, [FromQuery] int? year = null)
        {
            var foods = await statisticRepository.Top5Food(merchantId, date: date, month: month, year: year);
            return Ok(foods);
        }

    }
}