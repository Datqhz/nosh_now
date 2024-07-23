using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IOrderStatusRepository : IRepository<OrderStatus>
    {
        Task<IEnumerable<OrderStatus>> FindByName(string name);
        Task<IEnumerable<OrderStatus>> GetAllStatusWithoutInitAndCancelStatus();
    }
}