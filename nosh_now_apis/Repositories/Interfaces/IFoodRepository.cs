using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IFoodRepository : IRepository<Food>
    {
        Task<IEnumerable<Food>> GetByMerchantWithoutCondition(int merchantId);
        Task<IEnumerable<Food>> GetByMerchantAndIsSelling(int merchantId);
        Task<IEnumerable<Food>> FindContainRegex(string regex);
    }
}