using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IFoodRepository : IRepository<Food>
    {
        Task<IEnumerable<Food>> GetByMerchant(int merchantId);
        Task<IEnumerable<Food>> FindContainRegex(string regex);
    }
}