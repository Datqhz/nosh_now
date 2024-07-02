using MyApp.Models;

namespace MyApp.Repositories.Interface
{
    public interface IOrderDetailRepository : IRepository<OrderDetail>
    {
        Task<IEnumerable<OrderDetail>> FindByOrder(int orderId);
    }
}