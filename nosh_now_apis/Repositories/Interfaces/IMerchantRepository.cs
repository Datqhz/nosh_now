using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IMerchantRepository : IRepository<Merchant>
    {
        Task<IEnumerable<Merchant>> FindContainRegex(string regex);
        Task<IEnumerable<Merchant>> GetAllMerchantIsOpening();
    }
}