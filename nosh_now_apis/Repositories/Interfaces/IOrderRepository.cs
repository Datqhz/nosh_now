using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IOrderRepository : IRepository<Order>
    {
        Task<IEnumerable<Order>> FindByMerchant(int merchantId);
        Task<IEnumerable<Order>> FindByEater(int eaterId);
        Task<IEnumerable<Order>> FindByShipper(int shipperId);
        Task<Order> FindByMerchantAndEater(int merchantId, int eaterId);
        Task<IEnumerable<Order>> GetAllWaitingToPickedUp();

    }
}