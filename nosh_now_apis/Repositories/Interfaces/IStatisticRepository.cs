using MyApp.Dtos.Response;

namespace MyApp.Repositories
{
    public interface IStatisticRepository
    {
        Task<int> CountOrderOfUserByRoleAndDate(int roleId, int userId, DateTime? date = null, int? year = null, int? month = null);
        // manager
        Task<int> CountAccountByRoleAndDate(int roleId, DateTime? date = null, int? year = null, int? month = null);
        Task<int> CountOrderByDate(DateTime? date = null, int? year = null, int? month = null);
        Task<double> CalcTotalTransactionAmountByDate(DateTime? date = null, int? year = null, int? month = null);
        // merchant
        Task<double> CalcTotalRevenueOfMerchantByDate(int merchantId, DateTime? date = null, int? year = null, int? month = null);
        Task<IEnumerable<FoodRevenueDto>> Top5Food(int merchantId, DateTime? date = null, int? year = null, int? month = null);
        // shipper
        Task<double> CalcTotalEarningOfShipperByDate(int shipperId, DateTime? date = null, int? year = null, int? month = null);
        
    }
}